$script:OpenAI_Key = "apikey"

function Start-ChatGPT {
    $key = $script:OpenAI_Key
    $url = "https://api.openai.com/v1/chat/completions"

    $body = [pscustomobject]@{
        "model"    = "gpt-4"
        "messages" = @(
            @{"role" = "system"; "content" = "You are an assistant" }
        )
    }
    $header = @{
        "Authorization" = "Bearer $key"
        "Content-Type"  = "application/json"
    }
    while ($true) {
        $message = Read-Host "Prompt"
        $body.messages+=@{"role"="user";"content"=$message}
        $bodyJSON = ($body | ConvertTo-Json -Compress)
        try {
            $res = Invoke-WebRequest -Headers $header -Body $bodyJSON -Uri $url -method post
            $output = ($res.content | ConvertFrom-Json).choices[0].message
            Write-Host ""
            Write-Host $output.content -ForegroundColor Green
            Write-Host "--------------"
            $body.messages+=$output
        }
        catch {
            Write-Error $error[-1]