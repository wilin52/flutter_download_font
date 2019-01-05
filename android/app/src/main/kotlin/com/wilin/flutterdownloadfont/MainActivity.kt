package com.wilin.flutterdownloadfont

import android.Manifest
import android.content.pm.PackageManager
import android.os.Binder
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
  private val permission = arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE)

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    if (PackageManager.PERMISSION_GRANTED !=
      checkPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, Binder.getCallingPid(), Binder.getCallingUid())) {
      requestPermissions(permission,0);
    } else {
      GeneratedPluginRegistrant.registerWith(this)
    }
  }

  override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    GeneratedPluginRegistrant.registerWith(this)
  }
}
