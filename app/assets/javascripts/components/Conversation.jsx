var Conversation = React.createClass({
  propTypes: {
    messages: React.PropTypes.array,
    conversation: React.PropTypes.object.isRequired
  },

  getDefaultProps() {
    return {
      messages: []
    }
  },

  getInitialState() {
    return {
      messages: this.props.messages
    }
  },

  componentDidMount() {
    const { conversation } = this.props
    var channel = pusher.subscribe(`convo_${conversation.id}`)

    channel.bind('new_message', function(data) {
      this.setState({
        messages: this.state.messages.concat(data)
      })
    }.bind(this))
  },

  componentWillUnmount() {
    pusher.unsubscribe(`convo_${conversation.id}`)
  },

  render: function() {
    const { messages } = this.state

    return (
      <div className="container clearfix">
        {
          messages.map((m) => {
            return this.renderMessage(m)
          })
        }
        {this.renderNewMessageForm()}
      </div>
    )
  },

  renderMessage(m) {
    if (m.sender_id) {
      return (
        <div className="col col-12 m1" key={m.id}>
          <div>
            <div className="col col-8 bg-silver p1 px2">{m.body}</div>
            <div className="col col-4">&nbsp;</div>
          </div>
        </div>
      )
    } else {
      return (
        <div className="col col-12 m1" key={m.id}>
          <div>
            <div className="col col-4">&nbsp;</div>
            <div className="col col-8 bg-aqua p1 px2">{m.body}</div>
          </div>
        </div>
      )
    }
  },

  renderNewMessageForm() {
    return (
      <div className="col col-12 mt3">
        <hr />
        <div className="flex flex-end mt2">
          <textarea className="autosize field flex-auto" ref="newMessage"></textarea>
          <div className="flex-none">
            <button className="btn btn-primary" onClick={this.handleSendMessage}>Send</button>
          </div>
        </div>
      </div>
    )
  },

  handleSendMessage() {
    const { conversation } = this.props
    const newMessageNode = React.findDOMNode(this.refs.newMessage)
    const messages = this.state.messages

    $.post(`/conversations/${conversation.id}/messages`, {
      body: newMessageNode.value
    })
    this.setState({
      messages: messages.concat({
        id: Date.now(),
        body: newMessageNode.value
      })
    }, () => {
      newMessageNode.value = ''
    })
  }
})
