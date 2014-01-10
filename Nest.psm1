
$NEST_UserAgent = "Nest/1.1.0.10 CFNetwork/548.0.4"
$NEST_Uri = "https://home.nest.com/user/login"

function Get-_NestTime {
    $ts = new-object TimeSpan (
        ([datetime]::Now).ToUniversalTime().Ticks - 
        (new-object DateTime (1970, 1, 1)).Ticks
    )
    "$([Math]::Round($ts.TotalMilliseconds))"
}

function Get-NestInfo($UserName=(gs Nest.UserName), $Password=(gs Nest.Password)) {
    $ret = Invoke-RestMethod -Method post -UserAgent $NEST_UserAgent -Uri $NEST_Uri -Body `
        "username=$([uri]::EscapeUriString($UserName))&password=$([uri]::EscapeUriString($Password))"

    Invoke-RestMethod -Uri "$($ret.urls.transport_url)/v2/mobile/user.$($ret.userid)" `
        -UserAgent $NEST_UserAgent -Headers `
        @{'Authorization'="Basic $($ret.access_token)"
          'X-nl-user-id' =$ret.userid
          'X-nl-protocol-version'='1'
          'X-nl-client-timestamp'=(Get-_NestTime)
          'Accept-Language'='en-us'}
}

Export-ModuleMember -Function Get-Nestinfo