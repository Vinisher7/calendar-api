module Observations
  class CreateObservation
    include Interactor

    def call
      observation = context.observation

      unless observation.save
        return context.fail!(error: 'Não foi possível registrar esta observação', cause: observation.errors.full_messages)
      end

      context.response = { message: 'Observação criada com sucesso!' }
    end
  end
end
