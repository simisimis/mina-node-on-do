[nodes]
%{ for index, ip in nodes ~}
mina-node-${index} ansible_host=${ip} ansible_user=${mina_user} ansible_become_pass=${become_pass} network=${network}
%{ endfor ~}
