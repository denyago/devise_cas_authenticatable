module DeviseCasAuthenticatable
  module SingleSignOut
    module Strategies
      class RailsCache < Base
          def store_session_id_for_index(session_index, session_id)
            logger.debug("Storing #{session_id} for index #{session_index}")
            sids = Rails.cache.read(cache_key(session_index)) || []
            sids << session_id
            Rails.cache.write(cache_key(session_index), sids)
          end

          def find_session_id_by_index(session_index)
            sids = Rails.cache.read(cache_key(session_index))
            logger.debug("Found session id(s) #{sids.inspect} for index #{session_index}")
            sids
          end

          def delete_session_index(session_index)
            logger.debug("Deleting index #{session_index}")
            Rails.cache.delete(cache_key(session_index))
          end

          def delete_session_id_by_index(session_index, session_id)
            logger.debug("Deleting #{session_id} for index #{session_index}")
            sids = Rails.cache.read(cache_key(session_index)) || []
            logger.debug("Failed to delete #{session_id} for index #{session_index}") unless sids.delete(session_id)
            Rails.cache.write(cache_key(session_index), sids)
          end

          private

          def cache_key(session_index)
            "devise_cas_authenticatable:#{session_index}"
          end
      end
    end
  end
end

::DeviseCasAuthenticatable::SingleSignOut::Strategies.add( :rails_cache, DeviseCasAuthenticatable::SingleSignOut::Strategies::RailsCache )
