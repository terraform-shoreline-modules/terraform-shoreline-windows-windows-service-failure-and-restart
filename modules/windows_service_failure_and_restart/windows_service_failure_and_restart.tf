resource "shoreline_notebook" "windows_service_failure_and_restart" {
  name       = "windows_service_failure_and_restart"
  data       = file("${path.module}/data/windows_service_failure_and_restart.json")
  depends_on = [shoreline_action.invoke_check_service_status,shoreline_action.invoke_service_log_checker,shoreline_action.invoke_windows_service_remediation]
}

resource "shoreline_file" "check_service_status" {
  name             = "check_service_status"
  input_file       = "${path.module}/data/check_service_status.sh"
  md5              = filemd5("${path.module}/data/check_service_status.sh")
  description      = "Next Step"
  destination_path = "/tmp/check_service_status.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "service_log_checker" {
  name             = "service_log_checker"
  input_file       = "${path.module}/data/service_log_checker.sh"
  md5              = filemd5("${path.module}/data/service_log_checker.sh")
  description      = "Check the logs and system events to determine the root cause of the service failure."
  destination_path = "/tmp/service_log_checker.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "windows_service_remediation" {
  name             = "windows_service_remediation"
  input_file       = "${path.module}/data/windows_service_remediation.sh"
  md5              = filemd5("${path.module}/data/windows_service_remediation.sh")
  description      = "If the service is stopped due to system failure, perform a system reboot and restart the service."
  destination_path = "/tmp/windows_service_remediation.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_service_status" {
  name        = "invoke_check_service_status"
  description = "Next Step"
  command     = "`chmod +x /tmp/check_service_status.sh && /tmp/check_service_status.sh`"
  params      = ["SERVICE_NAME"]
  file_deps   = ["check_service_status"]
  enabled     = true
  depends_on  = [shoreline_file.check_service_status]
}

resource "shoreline_action" "invoke_service_log_checker" {
  name        = "invoke_service_log_checker"
  description = "Check the logs and system events to determine the root cause of the service failure."
  command     = "`chmod +x /tmp/service_log_checker.sh && /tmp/service_log_checker.sh`"
  params      = ["LOG_FILE_PATH","SERVICE_NAME"]
  file_deps   = ["service_log_checker"]
  enabled     = true
  depends_on  = [shoreline_file.service_log_checker]
}

resource "shoreline_action" "invoke_windows_service_remediation" {
  name        = "invoke_windows_service_remediation"
  description = "If the service is stopped due to system failure, perform a system reboot and restart the service."
  command     = "`chmod +x /tmp/windows_service_remediation.sh && /tmp/windows_service_remediation.sh`"
  params      = ["SERVICE_NAME"]
  file_deps   = ["windows_service_remediation"]
  enabled     = true
  depends_on  = [shoreline_file.windows_service_remediation]
}

