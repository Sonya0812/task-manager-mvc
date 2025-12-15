$tasks = @()
$nextId = 1

function Add-TaskModel {
    param($description)
    $task = @{
        Id = $script:nextId
        Description = $description
        Completed = $false
        CreatedAt = Get-Date -Format "HH:mm dd.MM.yyyy"
    }
    $script:tasks += $task
    $script:nextId++
    return $task.Id
}

function Get-AllTasksModel {
    return $script:tasks
}

function Complete-TaskModel {
    param($id)
    foreach ($task in $script:tasks) {
        if ($task.Id -eq $id) {
            $task.Completed = $true
            return $true
        }
    }
    return $false
}

function Delete-TaskModel {
    param($id)
    $newTasks = @()
    $found = $false
    foreach ($task in $script:tasks) {
        if ($task.Id -ne $id) {
            $newTasks += $task
        } else {
            $found = $true
        }
    }
    $script:tasks = $newTasks
    return $found
}

function Show-MenuView {
    Clear-Host
    Write-Host "========================================"
    Write-Host "         TASK MANAGER (MVC)"
    Write-Host "========================================"
    Write-Host "Commands:"
    Write-Host "  add 'description'    - Add task"
    Write-Host "  list                 - Show all tasks"
    Write-Host "  complete ID          - Complete task"
    Write-Host "  delete ID            - Delete task"
    Write-Host "  clear                - Clear all"
    Write-Host "  help                 - Show help"
    Write-Host "  exit                 - Exit"
    Write-Host "========================================"
}

function Show-TasksView {
    param($tasksList)
    
    if ($tasksList.Count -eq 0) {
        Write-Host "No tasks"
        return
    }
    
    Write-Host ""
    Write-Host "ID  Status  Created           Description"
    Write-Host "----------------------------------------"
    foreach ($task in $tasksList) {
        $status = if ($task.Completed) { "[X]" } else { "[ ]" }
        Write-Host "$($task.Id.ToString().PadRight(3)) $status    $($task.CreatedAt)  $($task.Description)"
    }
    Write-Host "----------------------------------------"
    Write-Host "Total tasks: $($tasksList.Count)"
}

function Show-SuccessView {
    param($message)
    Write-Host ""
    Write-Host "SUCCESS: $message"
}

function Show-ErrorView {
    param($message)
    Write-Host ""
    Write-Host "ERROR: $message"
}


function Process-CommandController {
    param($command, $argument)
    
    switch ($command) {
        "add" {
            if (-not $argument) {
                Show-ErrorView "Enter task description"
                return
            }
            $taskId = Add-TaskModel $argument
            Show-SuccessView "Task #$taskId added: $argument"
        }
        
        "list" {
            $allTasks = Get-AllTasksModel
            Show-TasksView $allTasks
        }
        
        "complete" {
            if ($argument -notmatch '^\d+$') {
                Show-ErrorView "Enter task number"
                return
            }
            
            $result = Complete-TaskModel ([int]$argument)
            if ($result) {
                Show-SuccessView "Task #$argument completed"
            } else {
                Show-ErrorView "Task #$argument not found"
            }
        }
        
        "delete" {
            if ($argument -notmatch '^\d+$') {
                Show-ErrorView "Enter task number"
                return
            }
            
            $result = Delete-TaskModel ([int]$argument)
            if ($result) {
                Show-SuccessView "Task #$argument deleted"
            } else {
                Show-ErrorView "Task #$argument not found"
            }
        }
        
        "clear" {
            $script:tasks = @()
            Show-SuccessView "All tasks cleared"
        }
        
        "help" {
            Show-MenuView
        }
        
        "exit" {
            Write-Host ""
            Write-Host "Goodbye!"
            exit 0
        }
        
        default {
            Show-ErrorView "Unknown command: $command"
            Write-Host "Type 'help' for commands list"
        }
    }
}


Show-MenuView

while ($true) {
    $input = Read-Host "`nEnter command"
    
    $parts = $input.Split(' ', 2)
    $cmd = $parts[0]
    $arg = if ($parts.Count -gt 1) { $parts[1] } else { $null }
    
    Process-CommandController $cmd $arg
}
