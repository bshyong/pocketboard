var Conversation = React.createClass({
  propTypes: {
    messages: React.PropTypes.array,
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
    console.log('mounted')
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
        <div className="col col-12" key={m.id}>
          <div className="col col-8 bg-aqua p1 px2">{m.body}</div>
          <div className="col col-4"></div>
        </div>
      )
    } else {
      <div className="col col-12" key={m.id}>
        <div className="col col-4"></div>
        <div className="col col-8 bg-green p1 px2">{m.body}</div>
      </div>
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
    const newMessageNode = React.findDOMNode(this.refs.newMessage)
    console.log('sending', newMessageNode.value)
    newMessageNode.value = ''
  }
})