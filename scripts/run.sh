fsm=http://localhost:4000/api
id=$(curl --silent --request POST ${fsm}/create)
echo ${id}
curl --write-out "\n" --request GET ${fsm}/retrieve/${id}
curl --write-out "\n" --request PATCH ${fsm}/update/${id}?transition=schedule
curl --write-out "\n" --request GET ${fsm}/retrieve/${id}
curl --write-out "\n" --request PATCH ${fsm}/update/${id}?transition=start
curl --write-out "\n" --request GET ${fsm}/retrieve/${id}
curl --write-out "\n" --request PATCH ${fsm}/update/${id}?transition=run
curl --write-out "\n" --request GET ${fsm}/retrieve/${id}
curl --write-out "\n" --request PATCH ${fsm}/update/${id}?transition=process
curl --write-out "\n" --request GET ${fsm}/retrieve/${id}
curl --write-out "\n" --request PATCH ${fsm}/update/${id}?transition=success
curl --write-out "\n" --request GET ${fsm}/retrieve/${id}
curl --write-out "\n" --request PATCH ${fsm}/update/${id}?transition=done
curl --write-out "\n" --request GET ${fsm}/retrieve/${id}
curl --write-out "\n" --request PATCH ${fsm}/update/${id}?transition=hokuspokus
curl --write-out "\n" --request GET ${fsm}/retrieve/$(uuidgen)
curl --write-out "\n" --request DELETE ${fsm}/delete/${id}
