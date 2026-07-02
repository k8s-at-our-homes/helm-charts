---
description: 'Helm chart labelling strategy for Kubernetes workloads and supporting objects'
applyTo: 'charts/**'
---

# Helm Chart Labelling Strategy

## Purpose

Apply a consistent, workload-safe labelling strategy across all Helm charts in
this repository.

The key requirement is that a chart-only change must not roll a workload unless
the workload's own container image changes.

## Non-Negotiable Rule

- `spec.selector.matchLabels` and `spec.template.metadata.labels` must never
  include values derived from chart metadata such as `.Chart.Version` or
  `helm.sh/chart`.
- `helm.sh/chart` may appear only in top-level resource labels, not in selector
  labels or pod template labels.
- Do not use the same label set for object metadata, pod templates, and
  selectors.

## Standard Label Tiers

Every chart should expose three label helpers per application or component.

### `selectorLabels`

Use for immutable selectors only.

- `app.kubernetes.io/name`: actual application name, not chart name unless the
  chart and application are the same thing.
- `app.kubernetes.io/instance`: Helm release name.
- `app.kubernetes.io/component`: stable component role, such as `frontend`,
  `backend`, `database`, `resolver`, or a chart-specific equivalent.
- `app.kubernetes.io/part-of`: top-level system name.

Use `selectorLabels` for:

- `spec.selector.matchLabels`
- `volumeClaimTemplates[].metadata.labels` when a workload owns persistent
  volumes

### `podLabels`

Use for pod template labels.

- Include everything from `selectorLabels`.
- Add `app.kubernetes.io/version` from the component's own image tag or the
  most accurate upstream version source.
- Never add `helm.sh/chart` here.

Use `podLabels` for:

- `spec.template.metadata.labels`

### `objectLabels`

Use for top-level metadata on Kubernetes objects.

- Include everything from `podLabels`.
- Add `app.kubernetes.io/managed-by`: `.Release.Service`.
- Add `helm.sh/chart`: `{{ .Chart.Name }}-{{ .Chart.Version }}` with `+`
  replaced by `_` when needed.

Use `objectLabels` for:

- Deployment, StatefulSet, DaemonSet, Job, CronJob, Service, Ingress, Route,
  ConfigMap, Secret, ServiceMonitor, RBAC, CRDs, PVCs, and any other top-level
  object metadata.labels.

## Version Source Decision

Use the most accurate version source for the component being deployed.

1. If the chart renders the workload directly and owns the image value, use the
   component image tag from values.
2. If the chart wraps an upstream dependency that owns the image, use the
   upstream chart's app version.
3. If the image is pinned by digest, keep the existing digest-derived label
   logic.

Do not use `.Chart.Version` or `helm.sh/chart` as an application version.

## Component Naming

- Use the actual application or component name in `app.kubernetes.io/name`.
- Use a stable role name in `app.kubernetes.io/component`.
- Keep component names consistent within a chart.
- Prefer explicit per-component helper files over heavily parameterized helper
  reuse when it improves readability.

Examples of stable component names:

- `frontend`
- `resolver`
- `backend`
- `database`
- `photon`
- `photon-gateway`
- `api`
- `worker`
- `device-plugin`
- `monitoring`

## File Layout

- Keep shared chart-wide helpers in `templates/_helpers.tpl`.
- Put component-specific helpers in `templates/<component>/_helpers.tpl`.
- Avoid cross-component helper reuse when it obscures the rendered label
  intent.

## Coverage Expectations

Every rendered object should receive labels appropriate to its role.

- Workload objects get `objectLabels` on `metadata.labels`.
- Workload selectors get `selectorLabels`.
- Pod templates get `podLabels`.
- Non-workload resources still get `objectLabels` so they are queryable and
  traceable.

If a resource kind cannot safely accept a particular label tier, use the most
appropriate subset, but never leak chart metadata into selectors or pod
templates.

## Review Checklist

- `selectorLabels` contains only immutable selector labels.
- `podLabels` adds only the workload version label on top of `selectorLabels`.
- `objectLabels` is the only place `helm.sh/chart` appears.
- Pod template labels do not change when only the chart version changes.
- Every top-level rendered object has labels where the API supports them.