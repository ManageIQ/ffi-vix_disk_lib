#include <stdlib.h>
#include <stddef.h>
#include <stdarg.h>
#include <stdint.h>

typedef uint64_t uint64;
typedef  int64_t  int64;
typedef uint32_t uint32;
typedef  int32_t  int32;
typedef uint16_t uint16;
typedef  int16_t  int16;
typedef  uint8_t  uint8;
typedef   int8_t   int8;
typedef     char   Bool;
typedef uint64 VixError;

enum {
   VIX_OK = 0,
};

typedef struct VixDiskLibHandleStruct VixDiskLibHandleStruct;
typedef VixDiskLibHandleStruct *VixDiskLibHandle;
typedef void (VixDiskLibGenericLogFunc)(const char *fmt, va_list args);
struct VixDiskLibConnectParam;
typedef struct VixDiskLibConnectParam *VixDiskLibConnection;
typedef Bool (*VixDiskLibProgressFunc)(void *progressData,
                                       int percentCompleted);
typedef void (*VixDiskLibCompletionCB)(void *cbData, VixError result);
typedef enum {
   VIXDISKLIB_DISK_UNKNOWN = 256
} VixDiskLibDiskType;

typedef enum {
   VIXDISKLIB_ADAPTER_UNKNOWN = 256
} VixDiskLibAdapterType;

typedef uint64 VixDiskLibSectorType;

typedef struct {
   VixDiskLibDiskType           diskType;
   VixDiskLibAdapterType        adapterType;
   uint16                       hwVersion;
   VixDiskLibSectorType         capacity;
} VixDiskLibCreateParams;

typedef enum {
   VIXDISKLIB_CRED_UNKNOWN = 256
} VixDiskLibCredType;

typedef struct {
   uint32 cylinders;
   uint32 heads;
   uint32 sectors;
} VixDiskLibGeometry;

typedef struct {
   VixDiskLibGeometry   biosGeo;      // BIOS geometry for booting and partitioning
   VixDiskLibGeometry   physGeo;      // physical geometry
   VixDiskLibSectorType capacity;     // total capacity in sectors
   VixDiskLibAdapterType adapterType; // adapter type
   int numLinks;                      // number of links (i.e. base disk + redo logs)
   char *parentFileNameHint;          // parent file for a redo log
   char *uuid;                        // disk UUID
} VixDiskLibInfo;

typedef struct VixDiskLibConnectParamsState VixDiskLibConnectParamsState;

typedef struct {
   VixDiskLibSectorType offset;   // offset in sectors
   VixDiskLibSectorType length;
} VixDiskLibBlock;

typedef struct {
   uint32 numBlocks;
   VixDiskLibBlock blocks[1];
} VixDiskLibBlockList;

typedef struct {
   char *id;
   char *datastoreMoRef;
   char *ssId;
} VixDiskLibVStorageObjectSpec;

typedef enum {
   VIXDISKLIB_SPEC_UNKNOWN = 2
} VixDiskLibSpecType;

typedef struct {
   char *vmxSpec;     // URL like spec of the VM.
   char *serverName;  // Name or IP address of VC / ESX.
   char *thumbPrint;  // SSL Certificate thumb print.
   long privateUse;   // This value is ignored.
   VixDiskLibCredType credType;

   union VixDiskLibCreds {
      struct VixDiskLibUidPasswdCreds {
         char *userName; // User id and password on the
         char *password; // VC/ESX host.
      } uid;
      struct VixDiskLibSessionIdCreds { // Not supported in 1.0
         char *cookie;
         char *userName;
         char *key;
      } sessionId;
      struct VixDiskLibTicketIdCreds *ticketId; // Internal use only.
   } creds;

   uint32 port;        // port to use for authenticating with VC/ESXi host
   uint32 nfcHostPort; // port to use for establishing NFC connection to ESXi host

   char *vimApiVer;    // not used
   char reserved[8];   // internal use only
   VixDiskLibConnectParamsState *state; // internal use only

   union {
      VixDiskLibVStorageObjectSpec vStorageObjSpec;
   } spec;
   VixDiskLibSpecType specType;  // disk or VM spec
} VixDiskLibConnectParams;

VixError
VixDiskLib_InitEx(uint32 majorVersion,
                  uint32 minorVersion,
                  VixDiskLibGenericLogFunc *log,
                  VixDiskLibGenericLogFunc *warn,
                  VixDiskLibGenericLogFunc *panic,
                  const char* libDir,
                  const char* configFile)
{
	return VIX_OK;
}

VixError
VixDiskLib_Init(uint32 majorVersion,
                uint32 minorVersion,
                VixDiskLibGenericLogFunc *log,
                VixDiskLibGenericLogFunc *warn,
                VixDiskLibGenericLogFunc *panic,
                const char* libDir)
{
	return VIX_OK;
}

void
VixDiskLib_Exit(void)
{
}

const char *
VixDiskLib_ListTransportModes(void)
{
	return "";
}

VixError
VixDiskLib_Cleanup(const VixDiskLibConnectParams *connectParams,
                   uint32 *numCleanedUp, uint32 *numRemaining)
{
	return VIX_OK;
}

VixError
VixDiskLib_Connect(const VixDiskLibConnectParams *connectParams,
                   VixDiskLibConnection *connection)
{
	return VIX_OK;
}

VixError
VixDiskLib_PrepareForAccess(const VixDiskLibConnectParams *connectParams,
                            const char *identity)
{
	return VIX_OK;
}

VixError
VixDiskLib_ConnectEx(const VixDiskLibConnectParams *connectParams,
                     Bool readOnly,
                     const char *snapshotRef,
                     const char *transportModes,
                     VixDiskLibConnection *connection)
{
	return VIX_OK;
}

VixError
VixDiskLib_Disconnect(VixDiskLibConnection connection)
{
	return VIX_OK;
}

VixError
VixDiskLib_EndAccess(const VixDiskLibConnectParams *connectParams,
                     const char *identity)
{
	return VIX_OK;
}

VixError
VixDiskLib_Create(const VixDiskLibConnection connection,
                  const char *path,
                  const VixDiskLibCreateParams *createParams,
                  VixDiskLibProgressFunc progressFunc,
                  void *progressCallbackData)
{
	return VIX_OK;
}

VixError
VixDiskLib_CreateChild(VixDiskLibHandle diskHandle,
                       const char *childPath,
                       VixDiskLibDiskType diskType,
                       VixDiskLibProgressFunc progressFunc,
                       void *progressCallbackData)
{
	return VIX_OK;
}

VixError
VixDiskLib_Open(const VixDiskLibConnection connection,
                const char *path,
                uint32 flags,
                VixDiskLibHandle *diskHandle)
{
	return VIX_OK;
}

VixError
VixDiskLib_QueryAllocatedBlocks(VixDiskLibHandle diskHandle,
                                VixDiskLibSectorType startSector,
                                VixDiskLibSectorType numSectors,
                                VixDiskLibSectorType chunkSize,
                                VixDiskLibBlockList **blockList)
{
	return VIX_OK;
}

VixError
VixDiskLib_FreeBlockList(VixDiskLibBlockList *blockList)
{
	return VIX_OK;
}

VixError
VixDiskLib_GetInfo(VixDiskLibHandle diskHandle,
                   VixDiskLibInfo **info)
{
	return VIX_OK;
}

void
VixDiskLib_FreeInfo(VixDiskLibInfo *info)
{
}

const char *
VixDiskLib_GetTransportMode(VixDiskLibHandle diskHandle)
{
	return "";
}

VixError
VixDiskLib_Close(VixDiskLibHandle diskHandle)
{
	return VIX_OK;
}

VixError
VixDiskLib_Read(VixDiskLibHandle diskHandle,
                VixDiskLibSectorType startSector,
                VixDiskLibSectorType numSectors,
                uint8 *readBuffer)
{
	return VIX_OK;
}

VixError
VixDiskLib_ReadAsync(VixDiskLibHandle diskHandle,
                     VixDiskLibSectorType startSector,
                     VixDiskLibSectorType numSectors,
                     uint8 *readBuffer,
                     VixDiskLibCompletionCB callback,
                     void *cbData)
{
	return VIX_OK;
}

VixError
VixDiskLib_Write(VixDiskLibHandle diskHandle,
                 VixDiskLibSectorType startSector,
                 VixDiskLibSectorType numSectors,
                 const uint8 *writeBuffer)
{
	return VIX_OK;
}

VixError
VixDiskLib_WriteAsync(VixDiskLibHandle diskHandle,
                      VixDiskLibSectorType startSector,
                      VixDiskLibSectorType numSectors,
                      const uint8 *writeBuffer,
                      VixDiskLibCompletionCB callback,
                      void *cbData)
{
	return VIX_OK;
}

VixError
VixDiskLib_Flush(VixDiskLibHandle diskHandle)
{
	return VIX_OK;
}

VixError
VixDiskLib_Wait(VixDiskLibHandle diskHandle)
{
	return VIX_OK;
}

VixError
VixDiskLib_ReadMetadata(VixDiskLibHandle diskHandle,
                        const char *key,
                        char *buf,
                        size_t bufLen,
                        size_t *requiredLen)
{
	return VIX_OK;
}

VixError
VixDiskLib_WriteMetadata(VixDiskLibHandle diskHandle,
                         const char *key,
                         const char *val)
{
	return VIX_OK;
}

VixError
VixDiskLib_GetMetadataKeys(VixDiskLibHandle diskHandle,
                           char *keys,
                           size_t maxLen,
                           size_t *requiredLen)
{
	return VIX_OK;
}

VixError
VixDiskLib_Unlink(VixDiskLibConnection connection,
                  const char *path)
{
	return VIX_OK;
}

VixError
VixDiskLib_Grow(VixDiskLibConnection connection,
                const char *path,
                VixDiskLibSectorType capacity,
                Bool updateGeometry,
                VixDiskLibProgressFunc progressFunc,
                void *progressCallbackData)
{
	return VIX_OK;
}

VixError
VixDiskLib_Shrink(VixDiskLibHandle diskHandle,
                  VixDiskLibProgressFunc progressFunc,
                  void *progressCallbackData)
{
	return VIX_OK;
}

VixError
VixDiskLib_Defragment(VixDiskLibHandle diskHandle,
                      VixDiskLibProgressFunc progressFunc,
                      void *progressCallbackData)
{
	return VIX_OK;
}

VixError
VixDiskLib_Rename(const char *srcFileName,
                  const char *dstFileName)
{
	return VIX_OK;
}

VixError
VixDiskLib_Clone(const VixDiskLibConnection dstConnection,
                 const char *dstPath,
                 const VixDiskLibConnection srcConnection,
                 const char *srcPath,
                 const VixDiskLibCreateParams *vixCreateParams,
                 VixDiskLibProgressFunc progressFunc,
                 void *progressCallbackData,
                 Bool overWrite)
{
	return VIX_OK;
}

char *
VixDiskLib_GetErrorText(VixError err, const char *locale)
{
	return NULL;
}

void
VixDiskLib_FreeErrorText(char* errMsg)
{
}

VixError
VixDiskLib_IsAttachPossible(VixDiskLibHandle parent, VixDiskLibHandle child)
{
	return VIX_OK;
}

VixError
VixDiskLib_Attach(VixDiskLibHandle parent, VixDiskLibHandle child)
{
	return VIX_OK;
}

VixError
VixDiskLib_SpaceNeededForClone(VixDiskLibHandle diskHandle,
                               VixDiskLibDiskType cloneDiskType,
                               uint64* spaceNeeded)
{
	return VIX_OK;
}

VixError
VixDiskLib_CheckRepair(const VixDiskLibConnection connection,
                       const char *filename,
                       Bool repair)
{
	return VIX_OK;
}

VixError
VixDiskLib_GetConnectParams(const VixDiskLibConnection connection,
                            VixDiskLibConnectParams** connectParams)
{
	return VIX_OK;
}

void
VixDiskLib_FreeConnectParams(VixDiskLibConnectParams* connectParams)
{
}

VixDiskLibConnectParams *
VixDiskLib_AllocateConnectParams()
{
	return NULL;
}
