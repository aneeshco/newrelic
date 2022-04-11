resource "newrelic_alert_policy" "DEMO_POLICY" {
  name = "DEMO_POLICY"
}

resource "newrelic_nrql_alert_condition" "UNHEALTHYHOST_DEMO_POLICY_NLB" {
  account_id                   = var.accountid
  policy_id                    = newrelic_alert_policy.DEMO_POLICY.id
  type                         = "static"
  name                         = "UNHEALTHYHOST_DEMO_POLICY_NLB"
  description                  = "Alert when unhealthyhost count > 0 for NLB"
  enabled                      = true
  violation_time_limit_seconds = 259200
  aggregation_window           = 60
  aggregation_method           = "event_flow"
  aggregation_delay              = 120
  expiration_duration            = 600
  open_violation_on_expiration   = true
  close_violations_on_expiration = false  

  nrql {
    query             = "SELECT max(`aws.networkelb.UnHealthyHostCount`) as unhealthyHosts FROM Metric  WHERE metricName='aws.networkelb.UnHealthyHostCount'   facet displayName"
  }

  critical {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
  
  warning {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "STORAGE_DEMO_POLICY_K8sNode" {
  account_id                   = var.accountid
  policy_id                    = newrelic_alert_policy.DEMO_POLICY.id
  type                         = "static"
  name                         = "STORAGE_DEMO_POLICY_K8sNode"
  description                  = "Alert when Storage Utilization > 60, 80 "
  enabled                      = true
  violation_time_limit_seconds = 259200
  aggregation_window           = 60
  aggregation_method           = "event_flow"
  aggregation_delay              = 120
  expiration_duration            = 600
  open_violation_on_expiration   = true
  close_violations_on_expiration = false  

  nrql {
    query             = "SELECT average(fsCapacityUtilization) as storageUtil FROM K8sNodeSample facet nodeName "
  }

  critical {
    operator              = "above"
    threshold             = 80
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
  
  warning {
    operator              = "above"
    threshold             = 60
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "MEMORY_DEMO_POLICY_K8sNode" {
  account_id                   = var.accountid
  policy_id                    = newrelic_alert_policy.DEMO_POLICY.id
  type                         = "static"
  name                         = "MEMORY_DEMO_POLICY_K8sNode"
  description                  = "Alert when Memory Utilization > 60, 80 "
  enabled                      = true
  violation_time_limit_seconds = 259200
  aggregation_window           = 60
  aggregation_method           = "event_flow"
  aggregation_delay              = 120
  expiration_duration            = 600
  open_violation_on_expiration   = true
  close_violations_on_expiration = false  

  nrql {
    query             = "SELECT average(allocatableMemoryUtilization) as memUtil FROM K8sNodeSample facet nodeName "
  }

  critical {
    operator              = "above"
    threshold             = 80
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
  
  warning {
    operator              = "above"
    threshold             = 60
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "CPU_DEMO_POLICY_K8sNode" {
  account_id                   = var.accountid
  policy_id                    = newrelic_alert_policy.DEMO_POLICY.id
  type                         = "static"
  name                         = "CPU_DEMO_POLICY_K8sNode"
  description                  = "Alert when Memory Utilization > 60, 80 "
  enabled                      = true
  violation_time_limit_seconds = 259200
  aggregation_window           = 60
  aggregation_method           = "event_flow"
  aggregation_delay              = 120
  expiration_duration            = 600
  open_violation_on_expiration   = true
  close_violations_on_expiration = false  

  nrql {
    query             = "SELECT average(allocatableCpuCoresUtilization) as cpuUtil FROM K8sNodeSample facet nodeName "
  }

  critical {
    operator              = "above"
    threshold             = 80
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
  
  warning {
    operator              = "above"
    threshold             = 60
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}

# Notification channel
resource "newrelic_alert_channel" "alert_notification_email" {
  name = "your_channel_name"
  type = "email"

  config {
    recipients              = "your_email@your_domain.com"
    include_json_attachment = "1"
  }
}

# Link the above notification channel to your policy
resource "newrelic_alert_policy_channel" "alert_policy_email" {
  policy_id  = newrelic_alert_policy.DEMO_POLICY.id
  channel_ids = [
    newrelic_alert_channel.alert_notification_email.id
  ]
}