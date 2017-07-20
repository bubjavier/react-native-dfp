using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Com.Reactlibrary.RNDfp
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNDfpModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNDfpModule"/>.
        /// </summary>
        internal RNDfpModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNDfp";
            }
        }
    }
}
