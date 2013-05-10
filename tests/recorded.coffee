deferred = require('Deferred')

module.exports = (url, data) ->
  response = fetch(url,data)
  throw "\nNo recorded response for:\n#{url}\n#{data}\n" unless response?
  deferred().resolve(JSON.parse(response))

responses = {}
register = (url, query, response) ->
  responses["#{url}:#{query}"] = response

fetch = (url, query) ->
  responses["#{url}:#{query}"]


register 'url', '{"from":"Member","select":["Name"]}', '''
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

register 'url', '{"from":"Expression","select":[{"from":"Author as Member","select":["Name"]}]}', '''
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

register 'url', '{"from":"Expression","select":[{"from":"ExpressionsInConversation as Expression","select":[{"from":"Author as Member","select":["Name"]}]}]}', '''
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

register 'url', '{"from":"Member","select":["Name"],"where":{"ID":"Member:1017"}}', '''
[
  [
    {
      "_oid": "Member:1017",
      "Name": "Bob McBobertan"
    }
  ]
]
'''

register 'url', '{"from":"Member","select":["Name"],"filter":["ParticipatesInConversations.@Count>\'4\'"]}', '''
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