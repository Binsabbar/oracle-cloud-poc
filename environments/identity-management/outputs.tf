output "root_compartments" {
  value  = [for c in module.root_compartments.compartments: {
    "${c.name}" = {
      id = c.id
      root_id = c.compartment_id
    }}
  ]
}

output "project_compartments" {
  value  = {for c in module.project_compartments.compartments: 
    "${c.name}" => {
      id = c.id
      root_id = c.compartment_id
    }
  }
}