group "default" {
  targets = ["build"]
}

group "release-all" {
  targets = ["release"]
}

variable "REPO" {
  default = "bubylou/palworld"
}

variable "TAG" {
  default = "latest"
}

target "docker-metadata-action" {}

target "build" {
  context = "."
  dockerfile = "Dockerfile"
  tags = ["ghcr.io/${REPO}:latest", "ghcr.io/${REPO}:${TAG}",
          "docker.io/${REPO}:latest", "docker.io/${REPO}:${TAG}"]
}

target "build-dev" {
  inherits = ["build"]
  cache-from = ["type=registry,ref=ghcr.io/${REPO}"]
  cache-to = ["type=inline"]
}

target "docker-metadata-action" {}

target "release" {
  inherits = ["build", "docker-metadata-action"]
  cache-from = ["type=gha"]
  cache-to = ["type=gha,mode=max"]
  platforms = ["linux/amd64"]
  attest = [
    "type=provenance,mode=max",
    "type=sbom"
  ]
}
