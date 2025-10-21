
#!/bin/bash

# Antall generasjoner du ønsker å beholde
KEEP_GENERATIONS=5

echo "Lister opp nåværende generasjoner..."
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

echo "Sletter alle generasjoner unntatt de siste $KEEP_GENERATIONS..."
sudo nix-env --delete-generations +$KEEP_GENERATIONS --profile /nix/var/nix/profiles/system

#echo "Kjører garbage collection..."
#sudo nix-collect-garbage -d

echo "Fjerner ubrukte pakker fra Nix Store..."
sudo nix-store --gc

echo "Optimaliserer Nix Store..."
sudo nix-store --optimise

echo "Opprydding fullført! Du beholder de siste $KEEP_GENERATIONS generasjonene."
