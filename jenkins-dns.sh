IP=$(aws ec2 describe-instances --filters "Name=tag:name,Values=jenkins" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
echo '
{
  "Comment": "CREATE/DELETE/UPSERT a record ",
  "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "jenkins.pappik.online",
      "Type": "A",
      "TTL": 15,
      "ResourceRecords": [{ "Value": "IPADDRESS"}]
    }}]
}' | sed -e "s/IPADDRESS/${IP}/" >/tmp/jenkins.json

ZONE_ID="Z01783243D3S1K1FW0QID"
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file://tmp/jenkins.json | jq .
