module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name          = "application-asg"
  instance_name = "application-server"

  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = [element([for subnet in aws_subnet.private_subnet : subnet.id], 0)]


  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
      max_healthy_percentage = 100
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name        = "application-lt"
  launch_template_description = "Application Server Launch template"
  update_default_version      = true

  image_id          = var.app_server_image_id
  instance_type     = var.app_server_instance_type
  ebs_optimized     = true
  enable_monitoring = true
  security_groups   = [aws_security_group.appserver_sg.id]

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
      }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp2"
      }
    }
  ]

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  cpu_options = {
    core_count       = 1
    threads_per_core = 1
  }

  credit_specification = {
    cpu_credits = "standard"
  }

  # instance_market_options = {
  #   market_type = "spot"
  #   spot_options = {
  #     block_duration_minutes = 60
  #   }
  # }

  # This will ensure imdsv2 is enabled, required, and a single hop which is aws security
  # best practices
  # See https://docs.aws.amazon.com/securityhub/latest/userguide/autoscaling-controls.html#autoscaling-4
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  placement = {
    availability_zone = "us-west-1b"
  }

  # tag_specifications = [
  #   {
  #     resource_type = "instance"
  #     tags          = { WhatAmI = "Instance" }
  #   },
  #   {
  #     resource_type = "volume"
  #     tags          = { WhatAmI = "Volume" }
  #   },
  #   {
  #     resource_type = "spot-instances-request"
  #     tags          = { WhatAmI = "SpotInstanceRequest" }
  #   }
  # ]

  initial_lifecycle_hooks = [
    {
      name                  = "ExampleStartupLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 60
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                  = "ExampleTerminationLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 180
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]
  # Target scaling policy schedule based on average CPU load
  scaling_policies = {
    avg-cpu-policy-greater-than-50 = {
      policy_type               = "TargetTrackingScaling"
      estimated_instance_warmup = 1200
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
      }
    },
    predictive-scaling = {
      policy_type = "PredictiveScaling"
      predictive_scaling_configuration = {
        mode                         = "ForecastAndScale"
        scheduling_buffer_time       = 10
        max_capacity_breach_behavior = "IncreaseMaxCapacity"
        max_capacity_buffer          = 10
        metric_specification = {
          target_value = 32
          predefined_scaling_metric_specification = {
            predefined_metric_type = "ASGAverageCPUUtilization"
            resource_label         = "testLabel"
          }
          predefined_load_metric_specification = {
            predefined_metric_type = "ASGTotalCPUUtilization"
            resource_label         = "testLabel"
          }
        }
      }
    }
    
    scale-out = {
      name                      = "scale-out"
      adjustment_type           = "ExactCapacity"
      policy_type               = "StepScaling"
      estimated_instance_warmup = 120
      step_adjustment = [
        {
          scaling_adjustment          = 1
          metric_interval_lower_bound = 0
          metric_interval_upper_bound = 10
        },
        {
          scaling_adjustment          = 2
          metric_interval_lower_bound = 10
        }
      ]
    }
  }



  tags = {
    Environment = "dev"
  }
}