deferred = require('Deferred')

module.exports = (url, data) ->
  response = fetch(url,data)
  throw "\nNo recorded response for:\n#{url}\n#{data}\n" unless response?
  deferred().resolve(response)

responses = {}
registerJson = (url, query, response) ->
  responses["#{url}:#{query}"] = JSON.parse(response)

registerString = (url, query, response) ->
  responses["#{url}:#{query}"] = response

fetch = (url, query) ->
  responses["#{url}:#{query}"]


registerJson 'url', '{"from":"Member","select":["Name"]}', '''
[
  [
    {
      "_oid": "Member:20",
      "Name": "Administrator"
    },
    {
      "_oid": "Member:1017",
      "Name": "Bob McBobertan"
    },
    {
      "_oid": "Member:1047",
      "Name": "Ian B"
    },
    {
      "_oid": "Member:1048",
      "Name": "Ian Culling"
    },
    {
      "_oid": "Member:1049",
      "Name": "Matt Higgins"
    }
  ]
]
'''

registerJson 'url', '{"from":"Expression","select":[{"from":"Author as Member","select":["Name"]}]}', '''
[
  [
    {
      "_oid": "Expression:1008",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1011",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1012",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1013",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1014",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1015",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1019",
      "Author": [
        {
          "_oid": "Member:1017",
          "Name": "Bob McBobertan"
        }
      ]
    },
    {
      "_oid": "Expression:1020",
      "Author": [
        {
          "_oid": "Member:1017",
          "Name": "Bob McBobertan"
        }
      ]
    },
    {
      "_oid": "Expression:1021",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1022",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1023",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1024",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1025",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1026",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1027",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1028",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1029",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1030",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1031",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1032",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1033",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1034",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1035",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1036",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1037",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1038",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1039",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1040",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1041",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1042",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1043",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1044",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1045",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1046",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1050",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1051",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1052",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1053",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1054",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1067",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    },
    {
      "_oid": "Expression:1068",
      "Author": [
        {
          "_oid": "Member:20",
          "Name": "Administrator"
        }
      ]
    }
  ]
]
'''

registerJson 'url', '{"from":"Expression","select":[{"from":"ExpressionsInConversation as Expression","select":[{"from":"Author as Member","select":["Name"]}]}]}', '''
[
  [
    {
      "_oid": "Expression:1008",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1008",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1011",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1011",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        },
        {
          "_oid": "Expression:1012",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1012",
      "ExpressionsInConversation": []
    },
    {
      "_oid": "Expression:1013",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1013",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        },
        {
          "_oid": "Expression:1014",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1014",
      "ExpressionsInConversation": []
    },
    {
      "_oid": "Expression:1015",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1015",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1019",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1019",
          "Author": [
            {
              "_oid": "Member:1017",
              "Name": "Bob McBobertan"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1020",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1020",
          "Author": [
            {
              "_oid": "Member:1017",
              "Name": "Bob McBobertan"
            }
          ]
        },
        {
          "_oid": "Expression:1021",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        },
        {
          "_oid": "Expression:1022",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1021",
      "ExpressionsInConversation": []
    },
    {
      "_oid": "Expression:1022",
      "ExpressionsInConversation": []
    },
    {
      "_oid": "Expression:1023",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1023",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1024",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1024",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1025",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1025",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1026",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1026",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1027",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1027",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1028",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1028",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1029",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1029",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1030",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1030",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        },
        {
          "_oid": "Expression:1031",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1031",
      "ExpressionsInConversation": []
    },
    {
      "_oid": "Expression:1032",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1032",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1033",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1033",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        },
        {
          "_oid": "Expression:1034",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        },
        {
          "_oid": "Expression:1035",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1034",
      "ExpressionsInConversation": []
    },
    {
      "_oid": "Expression:1035",
      "ExpressionsInConversation": []
    },
    {
      "_oid": "Expression:1036",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1036",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1037",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1037",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1038",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1038",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1039",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1039",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1040",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1040",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1041",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1041",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1042",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1042",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        },
        {
          "_oid": "Expression:1046",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1043",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1043",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1044",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1044",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1045",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1045",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1046",
      "ExpressionsInConversation": []
    },
    {
      "_oid": "Expression:1050",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1050",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1051",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1051",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        },
        {
          "_oid": "Expression:1068",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1052",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1052",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1053",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1053",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1054",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1054",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1067",
      "ExpressionsInConversation": [
        {
          "_oid": "Expression:1067",
          "Author": [
            {
              "_oid": "Member:20",
              "Name": "Administrator"
            }
          ]
        }
      ]
    },
    {
      "_oid": "Expression:1068",
      "ExpressionsInConversation": []
    }
  ]
]
'''

registerJson 'url', '{"from":"Member","select":["Name"],"where":{"ID":"Member:1017"}}', '''
[
  [
    {
      "_oid": "Member:1017",
      "Name": "Bob McBobertan"
    }
  ]
]
'''

registerJson 'url', '{"from":"Member","select":["Name"],"filter":["ParticipatesInConversations.@Count>\'4\'"]}', '''
[
  [
    {
      "_oid": "Member:20",
      "Name": "Administrator"
    },
    {
      "_oid": "Member:1049",
      "Name": "Matt Higgins"
    }
  ]
]
'''

registerJson 'url', '{"from":"Member","select":["Name"],"where":{"Scopes.@Count":2}}', '''
[
  [
    {
      "_oid": "Member:20",
      "Name": "Administrator"
    }
  ]
]
'''

registerJson 'url', '{"from":"Member","select":["Name","ParticipatesInConversations.@Count",{"from":"ParticipatesInConversations as Expression","select":["Content"]}]}', '''
[
  [
    {
      "_oid": "Member:20",
      "Name": "Administrator",
      "ParticipatesInConversations.@Count": "31",
      "ParticipatesInConversations": [
        {
          "_oid": "Expression:1008",
          "Content": "garbage!"
        },
        {
          "_oid": "Expression:1011",
          "Content": "test meats"
        },
        {
          "_oid": "Expression:1013",
          "Content": "trash!"
        },
        {
          "_oid": "Expression:1015",
          "Content": "conversation"
        },
        {
          "_oid": "Expression:1020",
          "Content": "hey people?!"
        },
        {
          "_oid": "Expression:1023",
          "Content": "moar"
        },
        {
          "_oid": "Expression:1024",
          "Content": "moar!!!"
        },
        {
          "_oid": "Expression:1025",
          "Content": "MOAR?!?!?!"
        },
        {
          "_oid": "Expression:1026",
          "Content": "what?!"
        },
        {
          "_oid": "Expression:1027",
          "Content": "maor?!"
        },
        {
          "_oid": "Expression:1028",
          "Content": "moar?!"
        },
        {
          "_oid": "Expression:1029",
          "Content": "evan MOAR?!"
        },
        {
          "_oid": "Expression:1030",
          "Content": "moars?!"
        },
        {
          "_oid": "Expression:1032",
          "Content": "here in test space"
        },
        {
          "_oid": "Expression:1033",
          "Content": "Talking about test in a space"
        },
        {
          "_oid": "Expression:1036",
          "Content": "10"
        },
        {
          "_oid": "Expression:1037",
          "Content": "9"
        },
        {
          "_oid": "Expression:1038",
          "Content": "8"
        },
        {
          "_oid": "Expression:1039",
          "Content": "7"
        },
        {
          "_oid": "Expression:1040",
          "Content": "6"
        },
        {
          "_oid": "Expression:1041",
          "Content": "5"
        },
        {
          "_oid": "Expression:1042",
          "Content": "4"
        },
        {
          "_oid": "Expression:1043",
          "Content": "3"
        },
        {
          "_oid": "Expression:1044",
          "Content": "2"
        },
        {
          "_oid": "Expression:1045",
          "Content": "1"
        },
        {
          "_oid": "Expression:1050",
          "Content": "hi"
        },
        {
          "_oid": "Expression:1051",
          "Content": "1"
        },
        {
          "_oid": "Expression:1052",
          "Content": "2"
        },
        {
          "_oid": "Expression:1053",
          "Content": "3"
        },
        {
          "_oid": "Expression:1054",
          "Content": "4"
        },
        {
          "_oid": "Expression:1067",
          "Content": "Space-ing it up!"
        }
      ]
    },
    {
      "_oid": "Member:1017",
      "Name": "Bob McBobertan",
      "ParticipatesInConversations.@Count": "2",
      "ParticipatesInConversations": [
        {
          "_oid": "Expression:1019",
          "Content": "Herro, anyone?"
        },
        {
          "_oid": "Expression:1020",
          "Content": "hey people?!"
        }
      ]
    },
    {
      "_oid": "Member:1047",
      "Name": "Ian B",
      "ParticipatesInConversations.@Count": "0",
      "ParticipatesInConversations": []
    },
    {
      "_oid": "Member:1048",
      "Name": "Ian Culling",
      "ParticipatesInConversations.@Count": "0",
      "ParticipatesInConversations": []
    },
    {
      "_oid": "Member:1049",
      "Name": "Matt Higgins",
      "ParticipatesInConversations.@Count": "5",
      "ParticipatesInConversations": [
        {
          "_oid": "Expression:1050",
          "Content": "hi"
        },
        {
          "_oid": "Expression:1051",
          "Content": "1"
        },
        {
          "_oid": "Expression:1052",
          "Content": "2"
        },
        {
          "_oid": "Expression:1053",
          "Content": "3"
        },
        {
          "_oid": "Expression:1054",
          "Content": "4"
        }
      ]
    }
  ]
]
'''

registerJson 'url', "{\"from\":\"Member\"}\n---\n{\"from\":\"ExpressionSpace\"}", '''
[
  [
    {
      "_oid": "Member:20"
    },
    {
      "_oid": "Member:1017"
    },
    {
      "_oid": "Member:1047"
    },
    {
      "_oid": "Member:1048"
    },
    {
      "_oid": "Member:1049"
    }
  ],
  [
    {
      "_oid": "ExpressionSpace:1005"
    },
    {
      "_oid": "ExpressionSpace:1006"
    },
    {
      "_oid": "ExpressionSpace:1007"
    },
    {
      "_oid": "ExpressionSpace:1009"
    },
    {
      "_oid": "ExpressionSpace:1055"
    },
    {
      "_oid": "ExpressionSpace:1056"
    },
    {
      "_oid": "ExpressionSpace:1057"
    },
    {
      "_oid": "ExpressionSpace:1058"
    },
    {
      "_oid": "ExpressionSpace:1059"
    },
    {
      "_oid": "ExpressionSpace:1060"
    },
    {
      "_oid": "ExpressionSpace:1061"
    },
    {
      "_oid": "ExpressionSpace:1062"
    },
    {
      "_oid": "ExpressionSpace:1063"
    },
    {
      "_oid": "ExpressionSpace:1064"
    },
    {
      "_oid": "ExpressionSpace:1065"
    },
    {
      "_oid": "ExpressionSpace:1066"
    }
  ]
]
'''

registerString '/VersionOne/rest-1.v1/Data/Expression', '<Asset></Asset>', '''
<Asset href="/VersionOne.Web/rest-1.v1/Data/Expression/1114/1245" id="Expression:1114:1245">
  <Attribute name="Content">Hello</Attribute>
</Asset>
'''