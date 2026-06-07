# Trash Frive marketing emails in Subscriptions older than 1 month
# Keeps: order, delivery, shipped, confirmation, receipt, invoice, welcome

$cutoff = (Get-Date).AddMonths(-1).ToString("yyyy/MM/dd")
$query = "from:hello@frive.co.uk label:subscriptions before:$cutoff"

$raw = gws gmail users messages list --params "{`"userId`":`"me`",`"q`":`"$query`",`"maxResults`":500}" 2>$null
$json = $raw | Select-String -Pattern '\{' -Raw | Select-Object -First 1
if (-not $json) { $raw | Select-String '\{' -Context 0,100 | Out-Null }

# Parse via python for reliability
$ids = $raw | python3 -c "
import sys, json
raw = sys.stdin.read()
start = raw.index('{')
data = json.loads(raw[start:])
msgs = data.get('messages', [])
print(' '.join(m['id'] for m in msgs))
" 2>$null

if (-not $ids) {
    Write-Output "No Frive emails to trash."
    exit 0
}

$idList = $ids -split ' '
Write-Output "Trashing $($idList.Count) Frive emails older than $cutoff..."

$body = '{"ids":["' + ($idList -join '","') + '"],"addLabelIds":["TRASH"],"removeLabelIds":["Label_27"]}'
gws gmail users messages batchModify --params '{"userId":"me"}' --json $body 2>$null
Write-Output "Done."
