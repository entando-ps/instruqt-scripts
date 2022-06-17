#!/bin/bash -l

SECONDS=0

echo "============================== Entando Setup Script started =============================="

# shellcheck disable=SC2035
chmod +x *.sh

source ./install-cert-manager.sh

source ./install-certificate.sh

source ./install-entando.sh

# source ./patch-cm.sh

source ./patch-kc.sh

echo '****************START BASH PROFILE****************'
cat <<EOT >> ../.bashrc
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -s "\$HOME/.entando/activate" ] && source \$HOME/.entando/activate --quiet --force 2>/dev/null
EOT
echo '****************END BASH PROFILE****************'



# elapsed time
duration=$SECONDS
echo '****************ELAPSED TIME****************'
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
