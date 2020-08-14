fsm=http://localhost:4000
id=$(curl --silent ${fsm}/create)
curl --write-out "\n" ${fsm}/retrieve/${id}
curl --write-out "\n" ${fsm}/update/${id}?transition=start
curl --write-out "\n" ${fsm}/retrieve/${id}
curl --write-out "\n" ${fsm}/update/${id}?transition=run
curl --write-out "\n" ${fsm}/retrieve/${id}
curl --write-out "\n" ${fsm}/update/${id}?transition=done
curl --write-out "\n" ${fsm}/retrieve/${id}
curl --write-out "\n" ${fsm}/update/${id}?transition=done
curl --write-out "\n" ${fsm}/retrieve/$(uuidgen)
curl --write-out "\n" ${fsm}/delete/${id}
