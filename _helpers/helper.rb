module YDAPI
  module Helpers
    class Helper
      @@logger = SYSTEM_LOGGER
      @@config = CONF

      def Helper.new_user_id(base_user_id)
        begin
          @@logger.info("#{self}.new_user_id(#{base_user_id})")
          if base_user_id.to_i > 0
            return "#{base_user_id.to_i + 1}"
          end
          nil
        rescue Exception => e
          @@logger.error("#{self}.new_user_id(#{base_user_id}) Exception:#{e}")
          nil
        end
      end

      def Helper.new_customer_id(base_customer_id)
        begin
          @@logger.info("#{self}.new_customer_id(#{base_customer_id})")
          if base_customer_id.to_i > 0
            return "#{base_customer_id.to_i + 1}"
          end
          nil
        rescue Exception => e
          @@logger.error("#{self}.new_customer_id(#{base_customer_id}) Exception:#{e}")
          nil
        end
      end

      def Helper.new_product_id(base_product_id)
        begin
          @@logger.info("#{self}.new_product_id(#{base_product_id})")
          if base_product_id.to_i > 0
            return "#{base_product_id.to_i + 1}"
          end
          nil
        rescue Exception => e
          @@logger.error("#{self}.new_product_id(#{base_product_id}) Exception:#{e}")
          nil
        end
      end

      def Helper.new_step1_id(base_id)
        begin
          @@logger.info("#{self}.new_step1_id(#{base_id})")
          if base_id.to_i > 0
            return "#{base_id.to_i + 1}"
          end
          nil
        rescue Exception => e
          @@logger.error("#{self}.new_step1_id(#{base_id}) Exception:#{e}")
          nil
        end
      end

      def Helper.get_scopes_by_user_authority(authority)
        begin
          if authority > 0
            scopes = @@config["authority_scope_#{authority}"]
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_scopes_by_user_authority(#{authority}) Exception:#{e}")
          nil
        end
      end

      # user_authority: 'hr:r,order:rw'
      def Helper.get_authority_hash(default_hash,user_authority)
        begin
          if user_authority.size>0
            auth_arr=user_authority.split(',')
            for at in auth_arr
              kv=at.split(':')
              default_hash[kv[0]]=kv[1]
            end
          end
          default_hash
        rescue Exception => e
          @@logger.error("#{self}.get_authority_hash(#{user_authority}) Exception:#{e}")
          nil
        end
      end

      def Helper.generate_application_id
        begin
          now=Time.now.utc.to_s
          "AP#{now[0,4]}#{now[5,2]}#{now[8,2]}#{now[11,2]}#{now[14,2]}_#{('a'..'z').to_a.shuffle[0..3].join.upcase}"
        rescue Exception=>e
          @@logger.error("#{self}.generate_application_id() Exception:#{e}")
          nil
        end
      end

      def Helper.generate_contract_id
        begin
          now=Time.now.utc.to_s
          "YD_#{now[0,4]}#{now[5,2]}#{now[8,2]}_#{('a'..'z').to_a.shuffle[0..5].join.upcase}"
        rescue Exception=>e
          @@logger.error("#{self}.generate_contract_id() Exception:#{e}")
          nil
        end
      end

      def Helper.generate_wh_raw_material_wh_id(name,specification)
        begin
          key="#{name.gsub(/\s+/, '')}#{specification.gsub(/\s+/, '')}"
          "WH_RM#{Digest::MD5.hexdigest(key)[0,8].upcase}"
        rescue Exception=>e
          @@logger.error("#{self}.generate_wh_raw_material_id(#{name},#{specification}) Exception:#{e}")
          nil
        end
      end

      def Helper.generate_wh_raw_material_wh_sub_id(wh_id,sub_key)
        begin
          "#{wh_id}_#{sub_key.to_s}_#{('a'..'z').to_a.shuffle[0..1].join.upcase}"
        rescue Exception=>e
          @@logger.error("#{self}.generate_wh_raw_material_id(#{name},#{specification}) Exception:#{e}")
          nil
        end
      end
    end
  end
end