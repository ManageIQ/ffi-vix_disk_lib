module FFI
  module VixDiskLib
    extend API
    extend FFI::Library
    class SafeConnectParams
      UidPasswd = API::UidPasswdCreds
      SessionId = API::SessionIdCreds
      #
      # Read the contents of a ConnectParams structure
      # into FFI memory for use when calling out to VixDiskLib
      #

      attr_reader :connect_params

      def set_param(in_conn_parms, symbol)
        conn_parms     = @connect_params + API::ConnectParams.offset_of(symbol)
        memory_pointer = get_mem_ptr_from_str(in_conn_parms[symbol])
        conn_parms.put_pointer(0, memory_pointer)
      end

      def initialize(in_conn_parms)
        conn_parms      = FFI::MemoryPointer.new(API::ConnectParams, 1, true)
        @connect_params = conn_parms
        set_param(in_conn_parms, :vmxSpec)
        # Increment structure pointer to server_name
        set_param(in_conn_parms, :serverName)
        # Increment structure pointer to thumbPrint
        set_param(in_conn_parms, :thumbPrint)
        # Increment structure pointer to privateUse
        conn_parms      = @connect_params + API::ConnectParams.offset_of(:privateUse)
        conn_parms.write_long(in_conn_parms[:privateUse]) unless in_conn_parms[:privateUse].nil?
        # Increment structure pointer to credType
        cred_type       = in_conn_parms[:credType]
        conn_parms      = @connect_params + API::ConnectParams.offset_of(:credType)
        conn_parms.write_int(cred_type) unless cred_type.nil?
        get_safe_creds(cred_type, in_conn_parms, @connect_params + API::ConnectParams.offset_of(:creds))
        conn_parms      = @connect_params + API::ConnectParams.offset_of(:port)
        conn_parms.write_uint32(in_conn_parms[:port]) unless in_conn_parms[:port].nil?
        @connect_params
      end

      #
      # Read a ConnectParams structure returned from the FFI layer from VixDiskLib_GetConnectParams
      # into a ruby hash.
      #
      def self.read(ffi_connect_parms)
        out_connect_parms              = {}
        spec_ptr                       =  ffi_connect_parms.get_pointer(API::ConnectParams.offset_of(:vmxSpec))
        out_connect_parms[:vmxSpec]    = spec_ptr.read_string unless spec_ptr.null?
        serv_ptr                       =  ffi_connect_parms.get_pointer(API::ConnectParams.offset_of(:serverName))
        out_connect_parms[:serverName] = serv_ptr.read_string unless serv_ptr.null?
        thumb_ptr                      = ffi_connect_parms.get_pointer(API::ConnectParams.offset_of(:thumbPrint))
        out_connect_parms[:thumbPrint] = thumb_ptr.read_string unless thumb_ptr.null?
        out_connect_parms[:privateUse] = ffi_connect_parms.get_long(API::ConnectParams.offset_of(:privateUse))
        out_connect_parms[:credType]   = ffi_connect_parms.get_long(API::ConnectParams.offset_of(:credType))
        cred_type                      = out_connect_parms[:credType]
        read_creds(cred_type, out_connect_parms, ffi_connect_parms + API::ConnectParams.offset_of(:creds))
        out_connect_parms
      end

      def self.set_params(id_symbol, name_symbol, creds, params)
        pointer             = creds + API::Creds.offset_of(id_symbol) + UidPasswd.offset_of(name_symbol)
        params[name_symbol] = read_safe_str_from_mem(pointer)
      end
      #
      # Read a ConnectParams Creds sub-structure returned from the FFI layer from VixDiskLib_GetConnectParams
      # into a ruby hash.
      #
      def self.read_creds(cred_type, conn_parms, ffi_creds)
        if cred_type == API::CredType[:VIXDISKLIB_CRED_UID]
          set_params(:uid, :userName, ffi_creds, conn_parms)
          set_params(:uid, :password, ffi_creds, conn_parms)
        elsif cred_type == API::CredType[:VIXDISKLIB_CRED_SESSIONID]
          set_params(:sessionId, :cookie, ffi_creds, conn_parms)
          set_params(:sessionId, :sessionUserName, ffi_creds, conn_parms)
          set_params(:sessionId, :key, ffi_creds, conn_parms)
        elsif cred_type == API::CredType[:VIXDISKLIB_CRED_TICKETID]
          set_params(:ticketId, :dummy, ffi_creds, conn_parms)
        end
      end

      private

      def self.read_safe_str_from_mem(mem_ptr)
        mem_str = mem_ptr.read_pointer
        mem_str.read_string unless mem_str.null?
      end

      def get_mem_ptr_from_str(str)
        return nil if str.nil?
        FFI::MemoryPointer.from_string(str)
      end

      def get_safe_creds(cred_type, in_creds, out_cred_ptr)
        if cred_type == API::VIXDISKLIB_CRED_UID
          get_safe_uid_creds(in_creds, out_cred_ptr)
        elsif cred_type == API::VIXDISKLIB_CRED_SESSIONID
          get_safe_sessionid_creds(in_creds, out_cred_ptr)
        elsif cred_type == API::VIXDISKLIB_CRED_TICKETID
          get_safe_ticketid_creds(in_creds, out_cred_ptr)
        elsif cred_type == API::VIXDISKLIB_CRED_SSPI
          vix_disk_lib_log.error "VixDiskLibApi.connect - Connection Parameters Credentials Type SSPI"
        elsif cred_type == API::VIXDISKLIB_CRED_UNKNOWN
          vix_disk_lib_log.error "VixDiskLibApi.connect - unknown Connection Parameters Credentials Type"
        end
      end

      def get_safe_uid_creds(in_creds, out_cred_ptr)
        # Increment structure pointer to creds field's username
        # This should take care of any padding necessary for the Union.
        conn_parms = out_cred_ptr + API::Creds.offset_of(:uid) + UidPasswd.offset_of(:userName)
        @user_name = in_creds[:userName] && FFI::MemoryPointer.from_string(in_creds[:userName])
        conn_parms.put_pointer(0, @user_name)
        # Increment structure pointer to creds field's password
        conn_parms = out_cred_ptr + API::Creds.offset_of(:uid) + UidPasswd.offset_of(:password)
        @password  = in_creds[:password] && FFI::MemoryPointer.from_string(in_creds[:password])
        conn_parms.put_pointer(0, @password)
      end

      def get_safe_sessionid_creds(in_creds, out_cred_ptr)
        conn_parms         = out_cred_ptr + API::Creds.offset_of(:sessionId) + SessionId.offset_of(:cookie)
        @cookie            = in_creds[:cookie] && FFI::MemoryPointer.from_string(in_creds[:cookie])
        conn_parms.put_pointer(0, @cookie)
        conn_parms         = out_cred_ptr + API::Creds.offset_of(:sessionId) + SessionId.offset_of(:sessionUserName)
        @session_user_name = in_creds[:sessionUserName] && FFI::MemoryPointer.from_string(in_creds[:sessionUserName])
        conn_parms.put_pointer(0, @session_user_name)
        conn_parms         = out_cred_ptr + API::Creds.offset_of(:sessionId) + SessionId.offset_of(:key)
        @key               = in_creds[:key] && FFI::MemoryPointer.from_string(in_creds[:key])
        conn_parms.put_pointer(0, @key)
      end

      def get_safe_ticketid_creds(in_creds, out_cred_ptr)
        conn_parms = out_cred_ptr + API::Creds.offset_of(:ticketId) + SessionId.offset_of(:dummy)
        @dummy     = in_creds[:dummy] && FFI::MemoryPointer.from_string(in_creds[:dummy])
        conn_parms.put_pointer(0, @dummy)
      end
    end
  end
end # class SafeConnectParams
