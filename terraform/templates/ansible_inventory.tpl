[nodes]
%{ for index, ip in nodes ~}
mina-node-${index} ansible_host=${ip} ansible_user=${user} ansible_become_pass=${become_pass}
%{ endfor ~}
