#!/bin/bash
DELEGATOR_ADDRESS='sif...'
VALIDATOR_ADDRESS='sifvaloper...'
PWD='password' # Пароль о ткошелька на ноде
DELAY=3600 # пауза между ределегирование в секундах
CHAIN_NAME='sifchain-1'

for (( ;; )); do
	echo -e "Get reward from Delegation"
	echo -e "${PWD}\n" | sifnoded tx distribution withdraw-rewards ${VALIDATOR_ADDRESS} --chain-id ${CHAIN_NAME} --from ${DELEGATOR_ADDRESS} --gas 2000000 --commission --yes

	echo -e "Wait 30 sec...\n"
	for (( timer=30; timer>0; timer-- ))
		do
		sleep 1
	done

	BAL=$(sifnoded q bank balances ${DELEGATOR_ADDRESS} -o json | jq -r '.balances | .[].amount')
	echo -e "Available Balance: ${BAL}rowan\n"
	
	echo -e "Stake ALL\n"
	echo -e "${PWD}\n" | sifnoded tx staking delegate ${VALIDATOR_ADDRESS} ${BAL}rowan --from ${DELEGATOR_ADDRESS} --gas 2000000 --chain-id ${CHAIN_NAME}  --yes

	echo -e "Wait ${DELAY} sec\n\n"
	for (( timer=${DELAY}; timer>0; timer-- ))
	do
		sleep 1
	done
done
