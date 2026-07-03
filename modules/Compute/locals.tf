locals {

  processed_instances = var.instances

  block_volume_attachments = flatten([

    for inst_name, inst in var.instances : [

      for vol in inst.block_volumes : {

        instance_name   = inst_name
        volume_id       = vol.volume_id
        attachment_type = vol.attachment_type

      }

    ]

  ])

}
