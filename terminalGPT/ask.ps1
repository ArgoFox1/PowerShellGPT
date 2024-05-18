$OpenAI_Key = "apikey"

function Get-ChatGPTResponse {
    param(
        [string]$prompt
    )

    $url = "https://api.openai.com/v1/completions"
    $body = @{
        "model" = "gpt-4"
        "prompt" = $prompt
        "temperature" = 0.7
        "max_tokens" = 150
    }
    $header = @{
        "Authorization" = "Bearer $OpenAI_Key"
        "Content-Type"  = "application/json"
    }

    try {
        $response = Invoke-RestMethod -Uri $url -Headers $header -Method Post -Body ($body | ConvertTo-Json)
        $output = $response.choices.text.trim()
        return $output
    }
    catch {
        Write-Error "Error occurred while querying OpenAI API: $_"
        return $null
    }
}

function Start-ChatGPT {
    Write-Host "Welcome to ChatGPT! You can start chatting. Type 'exit' to end the conversation."

    while ($true) {
        $userInput = Read-Host "You:"
        if ($userInput -eq "exit") {
            Write-Host "Goodbye!"
            break
        }
        
        $response = Get-ChatGPTResponse -prompt $userInput
        Write-Host "ChatGPT: $response"
    }
}
