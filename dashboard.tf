
resource "newrelic_one_dashboard" "DEMO_dashboard" {
  name = "DEMO"
  permissions = "public_read_write"

  page {
    name = "Home"

    widget_billboard {
      title = "OpenIncidents"
      row = 1
      column = 1
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "FROM(SELECT latest(event) as event, latest(priority) as priority FROM NrAiIncident facet conditionId, incidentId) SELECT filter(count(*),WHERE event='open') as openIncidentCount facet priority limit max"
      }
    }

    widget_billboard {
      title = "Node Uptime"
      row = 1
      column = 5
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "FROM K8sNodeSample SELECT percentage(uniqueCount(nodeName),WHERE hostStatus='running') as 'Hosts Uptime' facet clusterName"
      }
    }

    widget_markdown {
      title = ""
      row = 1
      column = 9
      height = 3
      width = 4
      text = <<EOT
# DEMO Environments

This dashboard provides an overview of DEMO environment. 
- [x] Development
- [x] Integration
- [x] Production

https://example.com/
EOT
    }

    widget_table {
      title = "NLB UnhealthyHostCount"
      row = 4
      column = 1
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT max(`aws.networkelb.UnHealthyHostCount`) as unhealthyHosts FROM Metric  WHERE metricName='aws.networkelb.UnHealthyHostCount'   facet displayName limit max "
      }
    }

    widget_billboard {
      title = "Container Uptime%"
      row = 4
      column = 5
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "FROM K8sContainerSample SELECT percentage(uniqueCount(containerName),WHERE status='Running') as 'Container Uptime%' facet clusterName limit max"
      }
    }

    widget_billboard {
      title = "POD Uptime %"
      row = 4
      column = 9
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "FROM K8sPodSample SELECT percentage(uniqueCount(podName),WHERE status IN('Pending','Succeeded')) as 'POD Uptime %' facet clusterName limit max"
      }
    }

    widget_billboard {
      title = "DynamoDB Table Availability"
      row = 7
      column = 1
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "FROM DatastoreSample SELECT percentage(uniqueCount(provider.tableName),WHERE provider.tableStatus='ACTIVE') as 'Table Availability' where provider='DynamoDbTable' "
      }
    }

    widget_billboard {
      title = "EFS - IOLimit%"
      row = 7
      column = 5
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT  average(aws.efs.PercentIOLimit) as IOLimit FROM Metric where metricName IN('aws.efs.PercentIOLimit') AND tags.Name IN('tcp-aws0013-apse2-efs-tcp-DEMO-sd-hdev04','tcp-aws0013-apse2-efs-tcp-DEMO-sd-hintg03') facet tags.Name limit max"
      }
    }

    widget_table {
      title = "DynamoDB"
      row = 7
      column = 9
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT latest(provider.tableStatus) as status, latest(provider.tableSizeBytes)/(1024*1024) as tableSizeMB FROM DatastoreSample WHERE provider='DynamoDbTable'  facet provider.tableName as tableName limit max"
      }
    }

    widget_table {
      title = "Cluster"
      row = 10
      column = 1
      height = 2
      width = 8

      nrql_query {
        account_id = var.accountid
        query = "FROM Metric select uniqueCount(k8s.nodeName) as 'Nodes', filter(uniqueCount(k8s.podName), where k8s.status = 'Running') as 'Running Pods', filter(uniqueCount(k8s.podName), where k8s.status in ('Pending')) as 'Pending Pods', uniqueCount(k8s.podName) as 'Total Pods' facet k8s.clusterName limit max"
      }
    }
  }

  page {
    name = "NLB"

    widget_billboard {
      title = "Active Flow Count by NLB - Average"
      row = 1
      column = 1
      height = 3
      width = 3

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(aws.networkelb.ActiveFlowCount) as 'Active Flow Count' from Metric facet displayName limit max"
      }
    }

    widget_billboard {
      title = "Minimum Healthy Host Count Per NLB"
      row = 1
      column = 4
      height = 3
      width = 3

      nrql_query {
        account_id = var.accountid
        query = "SELECT min(aws.networkelb.HealthyHostCount) as 'Minimum Healthy Host Count' from Metric  facet aws.networkelb.LoadBalancer LIMIT MAX"
      }
    }

    widget_billboard {
      title = "Consumed LCUs by NLB - Sum"
      row = 1
      column = 7
      height = 3
      width = 3

      nrql_query {
        account_id = var.accountid
        query = "SELECT sum(aws.networkelb.ConsumedLCUs) as 'Consumed LCUs' from Metric facet displayName limit max"
      }
    }

    widget_markdown {
      title = ""
      row = 1
      column = 10
      height = 3
      width = 3
      text = <<EOT
 ![NLB](https://upload.wikimedia.org/wikipedia/commons/d/d2/AWS_Simple_Icons_Networking_Amazon_Elastic_Load_Balancer.svg)

NLB List
- [x] nlb1
- [X] nlb2
- [X] nlb3

EOT
    }

    widget_bar {
      title = "Processed Bytes by NLB - Average"
      row = 4
      column = 1
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(aws.networkelb.ProcessedBytes) as 'Processed Bytes' from Metric facet displayName limit max"
      }
    }

    widget_bar {
      title = "TCP Client Reset Count - Average"
      row = 4
      column = 5
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(aws.networkelb.TCP_Client_Reset_Count) as 'TCP Client Reset Count' from Metric facet displayName limit max"
      }
    }
  }

  page {
    name = "K8S"

    widget_table {
      title = "Nodes"
      row = 1
      column = 1
      height = 3
      width = 9

      nrql_query {
        account_id = var.accountid
        query = "FROM Metric select filter(uniqueCount(k8s.podName), where  k8s.status = 'Running') as 'Running Pods', filter(uniqueCount(k8s.podName), where k8s.status = 'Pending') as 'Pending Pods', average(k8s.node.allocatableCpuCoresUtilization) as 'CPU %', average(k8s.node.allocatableMemoryUtilization) as 'Mem %', average(k8s.node.fsCapacityUtilization)  as 'Disk Util %', average(k8s.node.netTxBytesPerSecond) as 'Network Bps', average(k8s.node.netErrorsPerSecond) as 'Network Err Per Sec' facet nodeName limit max"
      }
    }

    widget_markdown {
      title = ""
      row = 1
      column = 10
      height = 3
      width = 3
      text = <<EOT
![Kubernetes](https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/1200px-Kubernetes_logo_without_workmark.svg.png)
- [x] cluster1
- [x] cluster2
- [x] cluster3
EOT
    }

    widget_table {
      title = "Overall POD status"
      row = 4
      column = 1
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "FROM Metric select uniqueCount(k8s.podName) as 'Total Pods', filter(uniqueCount(k8s.podName), where k8s.status = 'Running') as 'Running Pods', filter(uniqueCount(k8s.podName), where k8s.status = 'Pending') as 'Pending Pods', filter(uniqueCount(k8s.podName), where k8s.status = 'Failed') as 'Failed Pods' LIMIT MAX"
      }
    }

    widget_table {
      title = "Pod Status by Cluster"
      row = 4
      column = 5
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "FROM Metric select uniqueCount(k8s.podName) as 'Pod Count' where k8s.status is not null facet k8s.clusterName AS 'Cluster Name', k8s.status AS 'Status' limit MAX "
      }
    }

    widget_table {
      title = "Latest Pending Pods"
      row = 4
      column = 9
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "FROM Metric select k8s.podName AS 'Pod Name', k8s.status AS 'Status' , k8s.clusterName AS 'Cluster Name' where k8s.status = 'Pending' limit max"
      }
    }

    widget_table {
      title = "Pod Restarts"
      row = 7
      column = 1
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT max(k8s.container.restartCount) - min(k8s.container.restartCount) FROM Metric FACET k8s.podName, k8s.namespaceName LIMIT MAX"
      }
    }

    widget_table {
      title = "Latest Failed PODs"
      row = 7
      column = 5
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "FROM Metric select k8s.podName AS 'Pod Name', k8s.status AS 'Status', k8s.clusterName AS 'Cluster Name' where k8s.status = 'Failed' limit max"
      }
    }

    widget_line {
      title = "Memory Usage by pod, container"
      row = 7
      column = 9
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(k8s.container.memoryWorkingSetUtilization) as 'Memory Used %' FROM Metric facet k8s.podName, k8s.containerName timeseries LIMIT max"
      }
    }

    widget_pie {
      title = "Event Breakdown"
      row = 10
      column = 1
      height = 3
      width = 5

      nrql_query {
        account_id = var.accountid
        query = "FROM InfrastructureEvent select max(event.count) as 'Event Count' where category = 'kubernetes'  and (event.reason like '%Fail%' or event.reason like '%Kill%' or event.reason like '%Evict%' or event.reason like '%BackOff%') facet event.reason limit max"
      }
    }

    widget_billboard {
      title = "CPU Util w.r.t Yesterday"
      row = 10
      column = 6
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "FROM K8sNodeSample SELECT average(allocatableCpuCoresUtilization) as cpuUtil facet nodeName COMPARE WITH 1 day ago"
      }
    }
  }

  page {
    name = "DynamoDB"

    widget_table {
      title = "Table Status, Size"
      row = 1
      column = 1
      height = 3
      width = 5

      nrql_query {
        account_id = var.accountid
        query = "SELECT latest(provider.tableStatus) as status, latest(provider.tableSizeBytes)/(1024*1024) as tableSizeMB FROM DatastoreSample WHERE provider='DynamoDbTable'  facet provider.tableName as tableName limit max"
      }
    }

    widget_line {
      title = "Consumed WCU, RCU per Table"
      row = 1
      column = 6
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(aws.dynamodb.ConsumedReadCapacityUnits.byTable) as 'Consumed RCUs', average(aws.dynamodb.ConsumedWriteCapacityUnits.byTable) as 'Consumed WCUs' FROM Metric  facet aws.dynamodb.TableName  TIMESERIES"
      }
    }

    widget_markdown {
      title = ""
      row = 1
      column = 10
      height = 3
      width = 3
      text = <<EOT
![DynamoDB](https://upload.wikimedia.org/wikipedia/commons/f/fd/DynamoDB.png)
- [x] dynamodb-table1
- [x] dynamodb-table2

EOT
    }

    widget_table {
      title = "Consumed WCUs, RCUs per GSI"
      row = 4
      column = 1
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(aws.dynamodb.ConsumedReadCapacityUnits.byGlobalSecondaryIndex) as 'Consumed RCUs', average(aws.dynamodb.ConsumedWriteCapacityUnits.byGlobalSecondaryIndex) as 'Consumed WCUs' FROM Metric  facet aws.dynamodb.GlobalSecondaryIndexName   limit max"
      }
    }

    widget_bar {
      title = "Replication Latency by Table"
      row = 4
      column = 5
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(`aws.dynamodb.ReplicationLatency`) FROM Metric facet aws.dynamodb.TableName limit max"
      }
    }

    widget_line {
      title = "Request Latency, by Operation"
      row = 4
      column = 9
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(`provider.getSuccessfulRequestLatency.Average`) as 'GetItem',average(`provider.putSuccessfulRequestLatency.Average`) as 'PutItem', average(`provider.deleteSuccessfulRequestLatency.Average`) as 'DeleteItem',average(`provider.updateSuccessfulRequestLatency.Average`) as 'UpdateItem',average(`provider.querySuccessfulRequestLatency.Average`) as 'Query',average(`provider.scanSuccessfulRequestLatency.Average`) as 'Scan',average(`provider.batchGetSuccessfulRequestLatency.Average`) as 'BatchGetItem',average(`provider.batchWriteSuccessfulRequestLatency.Average`) as 'BatchWriteItem' FROM DatastoreSample WHERE collector.name LIKE '%' TIMESERIES 30 minutes"
      }
    }

    widget_billboard {
      title = "SystemErrors - All table"
      row = 7
      column = 1
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT sum(`aws.dynamodb.ScanSystemErrors`) + sum(`aws.dynamodb.QuerySystemErrors`) + sum(`aws.dynamodb.DeleteSystemErrors`) + sum(`aws.dynamodb.updateSystemErrors`) + sum(`aws.dynamodb.updateSystemErrors`) + sum(`aws.dynamodb.batchWriteSystemErrors`) + sum(`aws.dynamodb.batchGetSystemErrors`) + sum(`aws.dynamodb.getSystemErrors`) as SystemErrors FROM DatastoreSample limit max"
      }
    }

    widget_billboard {
      title = "User Errors - All tables"
      row = 7
      column = 9
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT sum(`aws.dynamodb.UserErrors`) as 'Total User Errors' FROM DatastoreSample limit max"
      }
    }
  }

  page {
    name = "ASG"

    widget_billboard {
      title = "Minimum In Service Instance by ASG"
      row = 1
      column = 1
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT min(aws.autoscaling.GroupInServiceInstances) as 'In Service Instances' from Metric where metricName like 'aws.autoscaling%' facet aws.autoscaling.AutoScalingGroupName limit max"
      }
    }
  }

  page {
    name = "Nodes"

    widget_area {
      title = "CPU Used (Cores) by Node"
      row = 1
      column = 1
      height = 4
      width = 6

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(k8s.node.cpuUsedCores) FROM Metric FACET k8s.nodeName  TIMESERIES "
      }
    }

    widget_area {
      title = "Memory Used by Node"
      row = 1
      column = 7
      height = 4
      width = 6

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(k8s.node.allocatableMemoryUtilization) FROM Metric FACET k8s.nodeName  TIMESERIES "
      }
    }

    widget_area {
      title = "Disk Used by Node"
      row = 5
      column = 1
      height = 4
      width = 6

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(k8s.node.fsCapacityUtilization) FROM Metric FACET k8s.nodeName  TIMESERIES "
      }
    }

    widget_area {
      title = "Network Used by Node"
      row = 5
      column = 7
      height = 4
      width = 6

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(k8s.node.netTxBytesPerSecond) FROM Metric FACET k8s.nodeName  TIMESERIES "
      }
    }

    widget_billboard {
      title = "Node Status"
      row = 9
      column = 1
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "FROM K8sNodeSample SELECT filter(uniqueCount(nodeName),WHERE hostStatus='running') as 'Running Nodes', filter(uniqueCount(nodeName),WHERE hostStatus!='running') as 'Not Running Nodes', uniqueCount(nodeName) as 'Total Nodes'  "
      }
    }

    widget_billboard {
      title = "CPU compared with Yesterday"
      row = 9
      column = 5
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(k8s.node.cpuUsedCores) FROM Metric FACET k8s.nodeName COMPARE WITH 1 day ago "
      }
    }

    widget_billboard {
      title = "Memory Compared with Yesterday"
      row = 9
      column = 9
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(k8s.node.allocatableMemoryUtilization) FROM Metric FACET k8s.nodeName  COMPARE WITH 1 day ago "
      }
    }

    widget_billboard {
      title = "Storage Compared with Yesterday"
      row = 12
      column = 1
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(k8s.node.fsCapacityUtilization) FROM Metric FACET k8s.nodeName  COMPARE WITH  1 day ago"
      }
    }

    widget_billboard {
      title = "Network Compared with Yesterday"
      row = 12
      column = 5
      height = 3
      width = 4

      nrql_query {
        account_id = var.accountid
        query = "SELECT average(k8s.node.netTxBytesPerSecond) FROM Metric FACET k8s.nodeName COMPARE WITH 1 day ago"
      }
    }
  }
}
