module FFI
  module VixDiskLib
    class DiskInfo
      extend API

      attr_reader :info

      def geometry_attribute(info, offset_value, attribute)
        info.get_uint32(offset_value + Geometry.offset_of(attribute))
      end

      #
      # Initialize a hash with the disk info for the specified handle
      # using the VixDiskLib_GetInfo method.
      # This is a helper class for the VixDiskLib::Api::get_info method.
      #
      def initialize(disk_handle)
        ruby_info = {}
        info = FFI::MemoryPointer.new :pointer
        vix_error = ApiWrapper.get_info(disk_handle, info)
        ApiWrapper.check_error(vix_error, __method__)
        real_info = info.get_pointer(0)

        ruby_info[:biosGeo]             = {}
        ruby_info[:physGeo]             = {}
        bios_offset                     = API::Info.offset_of(:biosGeo)
        phys_offset                     = API::Info.offset_of(:biosGeo)
        ruby_info[:biosGeo][:cylinders] = geometry_attribute(real_info, bios_offset, :cylinders)
        ruby_info[:biosGeo][:heads]     = geometry_attribute(real_info, bios_offset, :heads)
        ruby_info[:biosGeo][:sectors]   = geometry_attribute(real_info, bios_offset, :sectors)
        ruby_info[:physGeo][:cylinders] = geometry_attribute(real_info, phys_offset, :cylinders)
        ruby_info[:physGeo][:heads]     = geometry_attribute(real_info, phys_offset, :heads)
        ruby_info[:physGeo][:sectors]   = geometry_attribute(real_info, phys_offset, :sectors)
        ruby_info[:capacity]            = real_info.get_uint64(API::Info.offset_of(:capacity))
        ruby_info[:adapterType]         = real_info.get_int(API::Info.offset_of(:adapterType))
        ruby_info[:numLinks]            = real_info.get_int(API::Info.offset_of(:numLinks))

        parent_info = real_info + API::Info.offset_of(:parentFileNameHint)
        parent_info_str = parent_info.read_pointer
        ruby_info[:parentFileNameHint]  = parent_info_str.read_string unless parent_info_str.null?
        uuid_info_str = (real_info + API::Info.offset_of(:uuid)).read_pointer
        ruby_info[:uuid]                = uuid_info_str.read_string unless uuid_info_str.null?
        @info = ruby_info
      end
    end
  end
end # class DiskInfo
