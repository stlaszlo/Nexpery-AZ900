locals {
  common_tags = {
    project      = "nexpery-beta-teach"
    environment  = "training-pod-beta"
    managed_by   = "terraform"
    region       = var.location
    cohort_start = "29-Jul-26"
    owner        = "Laszlo Stomp"
  }
}