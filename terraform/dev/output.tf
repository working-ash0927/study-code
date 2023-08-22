output "ansible" {
  value = try(module.ansible, null)
}
output "test" {
  value = try(module.test, null)
}
output "jump" {
  value = try(module.jump, null)
}
output "win" {
  value = try(module.failover-windows, null)
}
output "vpc" {
  value = try(module.vpc, null)
}
output "ad" {
  value = try(module.simple_ad, null)
}
output "sg" {
  value = try(module.sg_workspace, null)
}
output fsx_windows {
  value = try(module.win_fsx, null)
}
# output "k8s_control_plane" {
#   value = try(module.k8s_control_plane, null)
# }
# output "k8s_worker1" {
#   value = try(module.k8s_worker1, null)
# }
# output "k8s_nfs" {
#   value = try(module.nfs, null)
# }
