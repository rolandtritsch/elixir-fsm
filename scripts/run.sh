fsm=http://localhost:4000
id=$(curl --silent ${fsm}/create)
echo ${id}
curl --write-out "\n" ${fsm}/retrieve/${id}
curl --write-out "\n" ${fsm}/update/${id}?transition=schedule
curl --write-out "\n" ${fsm}/retrieve/${id}
curl --write-out "\n" ${fsm}/update/${id}?transition=start
curl --write-out "\n" ${fsm}/retrieve/${id}
curl --write-out "\n" ${fsm}/update/${id}?transition=run
curl --write-out "\n" ${fsm}/retrieve/${id}
curl --write-out "\n" ${fsm}/update/${id}?transition=process
curl --write-out "\n" ${fsm}/retrieve/${id}
curl --write-out "\n" ${fsm}/update/${id}?transition=success
curl --write-out "\n" ${fsm}/retrieve/${id}
curl --write-out "\n" ${fsm}/update/${id}?transition=done
curl --write-out "\n" ${fsm}/retrieve/${id}
curl --write-out "\n" ${fsm}/update/${id}?transition=hokuspokus
curl --write-out "\n" ${fsm}/retrieve/$(uuidgen)
curl --write-out "\n" ${fsm}/delete/${id}
