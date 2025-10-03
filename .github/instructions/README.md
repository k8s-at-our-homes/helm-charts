# Copilot Instruction Files

This directory contains GitHub Copilot instruction files that provide specialized guidance for DevOps, Kubernetes, and Infrastructure-as-Code best practices.

## Source

These instruction files are sourced from the [awesome-copilot](https://github.com/github/awesome-copilot) repository, which is a curated collection of best practices and instructions for GitHub Copilot.

## Installed Instructions

The following instruction files are included in this repository:

### Core DevOps & Infrastructure

- **devops-core-principles.instructions.md** - Foundational DevOps principles, CALMS framework, and DORA metrics
- **kubernetes-deployment-best-practices.instructions.md** - Comprehensive Kubernetes deployment best practices covering Pods, Deployments, Services, Ingress, ConfigMaps, Secrets, health checks, and security
- **containerization-docker-best-practices.instructions.md** - Docker and containerization best practices including multi-stage builds, image optimization, and security
- **github-actions-ci-cd-best-practices.instructions.md** - GitHub Actions workflow best practices for CI/CD pipelines

## How It Works

GitHub Copilot automatically applies these instructions based on the file patterns specified in each instruction file's `applyTo` field. For example:

- Kubernetes instructions apply to all files (`applyTo: '*'`)
- Docker instructions apply to Dockerfiles and docker-compose files
- GitHub Actions instructions apply to workflow files in `.github/workflows/`

## Usage

These instructions are automatically loaded by GitHub Copilot when you work on files matching their patterns. You don't need to do anything special - Copilot will use these instructions to provide more relevant and accurate suggestions.

## Updating Instructions

To update these instruction files to the latest version from awesome-copilot:

1. Visit https://github.com/github/awesome-copilot
2. Navigate to the `instructions/` directory
3. Copy the updated instruction files to `.github/instructions/`

## Repository-Specific Instructions

The main repository-specific Copilot instructions are located in `.github/copilot-instructions.md` at the root of the `.github` directory. Those instructions take precedence and are specific to this Helm charts repository.
