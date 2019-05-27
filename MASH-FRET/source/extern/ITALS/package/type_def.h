#ifndef __TYPE_DEF_H__
#define __TYPE_DEF_H__

/////////////////////// Microsoft compiler
#if defined(_MSC_VER)
// Integer types
typedef signed      __int8      axpSInt8;
typedef unsigned    __int8      axpUInt8;
typedef signed      __int16     axpSInt16;
typedef unsigned    __int16     axpUInt16;
typedef signed      __int32     axpSInt32;
typedef unsigned    __int32     axpUInt32;
typedef signed      __int64     axpSInt64;
typedef unsigned    __int64     axpUInt64;
// Real types
typedef             float       axpReal32;
typedef             double      axpReal64;
// Logical types
typedef             bool        axpBool;
// Void type
typedef             void        axpVoid;
// Char type
typedef             char        axpChar;
typedef             char*       axpPChar;
#endif //(_MSC_VER) 
// end Microsoft compiler////////////////
/////////////////////////// GNUC compiler
#if defined(__GNUC__)
// Integer types
typedef signed      char        axpSInt8;
typedef unsigned    char        axpUInt8;
typedef signed      short       axpSInt16;
typedef unsigned    short       axpUInt16;
typedef signed      int         axpSInt32;
typedef unsigned    int         axpUInt32;
typedef signed      long long   axpSInt64;
typedef unsigned    long long   axpUInt64;
// Real types
typedef             float       axpReal32;
typedef             double      axpReal64;
// Logical types
typedef             bool        axpBool;
// Void type
typedef             void        axpVoid;
// Char type
typedef             char        axpChar;
typedef             char*       axpPChar;
#endif //__GNUC__ 
// end GNUC compiler////////////////////  

#endif
