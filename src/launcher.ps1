#
# Copyright 2026 the original author jacky.eastmoon
#

# ------------------- shell setting -------------------

# ------------------- declare variable -------------------

$IMAGE_NAME = "hello-world"

# ------------------- declare function -------------------

# Use loop statement to find options in, if find it call processing function by LOOP_CALLBACK variable.

# ------------------- Main method -------------------

function check-container {
    docker image inspect $IMAGE_NAME 2>&1 | Out-Null
    if (-not $?) {
        docker pull $IMAGE_NAME
    }
}

function container {
    if (-not (Test-Path "$PSScriptRoot\cache")) { New-Item -Path "$PSScriptRoot\cache" -ItemType Directory  | Out-Null }
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    "$timestamp" | Out-File -FilePath "$PSScriptRoot\cache\$timestamp"
    docker run -ti --rm $IMAGE_NAME
}

function pre-action {
    [CmdletBinding()]
    Param(
        [switch]$Clean,

        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$UnknownParameters
    )

    if ($Clean) {
        if (Test-Path "$PSScriptRoot\cache") { Remove-Item "$PSScriptRoot\cache" -Recurse -Force }
    }
}

function post-action {
    [CmdletBinding()]
    Param(
        [string]$Output,

        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$UnknownParameters
    )

    if ($Output) {
        if (-not (Test-Path "$PSScriptRoot\$Output")) { New-Item -Path "$PSScriptRoot\$Output" -ItemType Directory  | Out-Null }
        if (Test-Path "$PSScriptRoot\cache") { Copy-Item -Path "$PSScriptRoot\cache\*" -Destination "$PSScriptRoot\$Output" -Recurse -Force }
    }
}
# ------------------- execute script -------------------

check-container
pre-action @args
container @args
post-action @args
