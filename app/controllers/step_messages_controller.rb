
class StepMessagesController < ApplicationController
  def new
    @step = Step.find(params[:step_id])
    @message = Message.new
  end
  
  def create
    @step = Step.find(params[:step_id])
    @message = @step.messages.new(params[:message])
    if @message.save
      redirect_to(@message, :notice => 'Bericht was succesvol aangemaakt.')
    else
      render :action => "new"
    end
  end
end
