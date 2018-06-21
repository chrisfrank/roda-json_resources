require 'rack/reducer'
require 'roar/decorator'
require 'roar/json'

class Roda
  module RodaPlugins
    module JSONResources
      module ClassMethods
        def self.extended(base)
          base.plugin :all_verbs
          base.plugin :json, classes: [Array, Hash, Representable]
          base.plugin :json_parser
          base.plugin :halt
          base.plugin :slash_path_empty
          base.class_eval <<-END
            class JSONDecorator < Roar::Decorator
              include Roar::JSON
            end
          END
        end
      end

      module RequestMethods
        def default_crud_actions
          %i(create read update destroy)
        end

        def crud(model, decorator:, actions: default_crud_actions)
          actions_enabled = actions.each_with_object({}) do |action, memo|
            memo[action] = true
          end
          instance_exec(model, decorator, actions_enabled, &CrudHandler)
        end

        def index(model, decorator:, filters:)
          root do
            decorator.for_collection.new(
              Rack::Reducer.call(params, dataset: model, filters: filters)
            )
          end
        end

        CrudHandler = lambda do |model, decorator, actions|
          actions[:create] && post do
            response.status = 201
            decorator.new(model.new).tap do |dec|
              dec.from_hash(params).save || halt(422, dec.represented.errors)
            end
          end

          is Integer do |id|
            @record = model.first(id: id) || halt(404)

            actions[:read] && get { decorator.new(@record) }

            actions[:update] && patch do
              decorator.new(@record).tap do |dec|
                dec.from_hash(params).save || halt(422, dec.represented.errors)
              end
            end

            actions[:destroy] && delete do
              response.status = 204
              @record.destroy
              { id: @record.id }
            end
          end
        end
      end
    end

    register_plugin :json_resources, JSONResources
  end
end
