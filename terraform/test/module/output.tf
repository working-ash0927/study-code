output "k8s_control_plane" {
  value = try(module.k8s_control_plane, null)
}
output "k8s_worker1" {
  value = try(module.k8s_worker1, null)
}
output "k8s_nfs" {
  value = try(module.nfs, null)
}
