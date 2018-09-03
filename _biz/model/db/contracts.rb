module YDAPI
  module BizModel
    module DBModel
      class Contracts < Sequel::Model(:contracts)
        @@logger=BIZ_MODEL_LOGGER
        def Contracts.func_add(contract)
          begin
            Contracts.create do |c|
              c.contract_id=contract.contract_id
              c.added_by_user_name=contract.added_by_user_name
              c.sign_by_user_name=contract.sign_by_user_name
              c.customer_id=contract.customer_id
              c.sign_at=contract.sign_at
              c.start_date=contract.start_date
              c.end_date=contract.end_date
              c.total_value=contract.total_value
              c.total_value_currency=contract.total_value_currency 
              c.description=contract.description
              c.comment=contract.comment
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{contract}) Exception:#{e}")
            nil
          end
        end

        def Contracts.func_delete(contract_id)
          begin
            Contracts[contract_id: contract_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{contract_id}) Exception:#{e}")
            nil
          end
        end

        def Contracts.func_update(contract)
          begin
            exist_c=Contracts[contract_id: contract.contract_id]
            new_c=exist_c.update(
                sign_by_user_name:contract.sign_by_user_name,
                customer_id:contract.customer_id,
                sign_at:contract.sign_at,
                start_date:contract.start_date,
                end_date:contract.end_date,
                contract_status:contract.contract_status,
                description:contract.description,
                comment:contract.comment
            )
            if new_c
              new_c
            else
              exist_c
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{contract}) Exception:#{e}")
            nil
          end
        end

        def Contracts.func_get(contract_id)
          begin
            Contracts[contract_id: contract_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{contract_id}) Exception:#{e}")
            nil
          end
        end

        def Contracts.func_get_by_id(id)
          begin
            Contracts[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id(#{id}) Exception:#{e}")
            nil
          end
        end

        def Contracts.func_get_all_by_user_name(user_name)
          begin
            Contracts.dataset.where(added_by_user_name:user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(user_name) Exception:#{e}")
            nil
          end
        end

        def Contracts.func_get_all_by_sign_user(sign_by_user_name)
          begin
            Contracts.dataset.where(sign_by_user_name:sign_by_user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(user_name) Exception:#{e}")
            nil
          end
        end

        def Contracts.func_get_max_contract_id
          begin
            Contracts.last.contract_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_contract_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end