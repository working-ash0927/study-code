module "mypw1" {
  source = "../modules"
}

module "mypw2" {
  source = "../modules"
  isDB   = true
}

output "mypw1" {
  value  = module.mypw1
}

output "mypw2" {
  value  = module.mypw2
}