class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :edit, :update, :destroy, :add_message]

  # GET /conversations
  # GET /conversations.json
  def index
    @conversations = Conversation.involved(current_user.id).includes(:messages)
    @users = User.where(id: @conversations.pluck(:inviter_id, :invitee_id).flatten.uniq - [current_user.id])
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    load_messages
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
  end

  # GET /conversations/1/edit
  def edit
  end

  # POST /conversations
  # POST /conversations.json
  def create
    @conversation = Conversation.new(conversation_params)

    respond_to do |format|
      if @conversation.save
        format.html { redirect_to @conversation, notice: 'Conversation was successfully created.' }
        format.json { render :show, status: :created, location: @conversation }
      else
        format.html { render :new }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conversations/1
  # PATCH/PUT /conversations/1.json
  def update
    respond_to do |format|
      if @conversation.update(conversation_params)
        format.html { redirect_to @conversation, notice: 'Conversation was successfully updated.' }
        format.json { render :show, status: :ok, location: @conversation }
      else
        format.html { render :edit }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    @conversation.destroy
    respond_to do |format|
      format.html { redirect_to conversations_url, notice: 'Conversation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_message
    @conversation.messages.create(message_params)
    load_messages
    respond_to do |format|
      format.html { render :show }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conversation_params
      params.permit(:inviter_id, :invitee_id)
    end

    def message_params
      params.permit(:sender_id, :reciever_id, :content)
    end

    def load_messages
      partner_id = [@conversation.inviter_id, @conversation.invitee_id] - [current_user.id]
      @partner = User.find(partner_id.first)
      @messages = Message.where(conversation_id: @conversation.id)
    end
end
