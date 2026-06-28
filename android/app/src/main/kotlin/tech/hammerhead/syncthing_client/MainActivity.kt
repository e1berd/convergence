package tech.hammerhead.syncthing_client

import android.content.Intent
import android.net.Uri
import android.provider.DocumentsContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "syncthing/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "nativeLibraryDir" -> result.success(applicationInfo.nativeLibraryDir)
                    "openFolder" -> result.success(openFolder(call.argument<String>("path")))
                    else -> result.notImplemented()
                }
            }
    }

    private fun openFolder(path: String?): Boolean {
        if (path.isNullOrEmpty()) return false
        val primary = "/storage/emulated/0"
        val docId = when {
            path == primary -> "primary:"
            path.startsWith("$primary/") -> "primary:" + path.removePrefix("$primary/")
            else -> "primary:" + path.substringAfter("/0/", "")
        }
        val uri = DocumentsContract.buildDocumentUri(
            "com.android.externalstorage.documents",
            docId,
        )
        for (target in listOf(uri, Uri.parse("content://com.android.externalstorage.documents/root/primary"))) {
            try {
                val intent = Intent(Intent.ACTION_VIEW)
                    .setDataAndType(target, "vnd.android.document/directory")
                    .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                return true
            } catch (_: Exception) {
            }
        }
        return false
    }
}
