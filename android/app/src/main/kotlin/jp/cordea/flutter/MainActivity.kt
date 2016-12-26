package jp.cordea.flutter

import android.app.Activity
import android.os.Bundle

import io.flutter.view.FlutterMain
import io.flutter.view.FlutterView
import io.realm.Realm
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : Activity() {

    private val flutterView: FlutterView by lazy {
        findViewById(R.id.flutter_view) as FlutterView
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FlutterMain.ensureInitializationComplete(applicationContext, null)
        setContentView(R.layout.activity_main)

        Realm.init(this)

        flutterView.runFromBundle(FlutterMain.findAppBundlePath(applicationContext), null)
        flutterView.addOnMessageListener("realm", { v, m ->
            val json = JSONObject(m)
            when (json.getString("method")) {
                "load" -> buildResult(loadAll())
                "save" -> {
                    save(json.getJSONObject("params"))
                    return@addOnMessageListener "{}"
                }
                "delete" -> {
                    deleteAll()
                    return@addOnMessageListener "{}"
                }
                "search" -> buildResult(search(json.getJSONObject("params")))
                else -> return@addOnMessageListener "{}"
            }
        })
    }

    override fun onDestroy() {
        flutterView.destroy()
        super.onDestroy()
    }

    override fun onPause() {
        super.onPause()
        flutterView.onPause()
    }

    override fun onPostResume() {
        super.onPostResume()
        flutterView.onPostResume()
    }

    private fun buildResult(results: Array<Person>): String {
        val json = JSONObject()
        val result = JSONArray()
        results.forEach {
            result.put(it.toJsonObject())
        }
        json.put("result", result)
        return json.toString()
    }

    private fun loadAll(): Array<Person> {
        val realm = Realm.getDefaultInstance()
        val results = realm.where(Person::class.java).findAll()
        return results.toTypedArray()
    }

    private fun deleteAll() {
        val realm = Realm.getDefaultInstance()
        val results = realm.where(Person::class.java).findAll()
        realm.executeTransaction {
            results.deleteAllFromRealm()
        }
    }

    private fun search(json: JSONObject): Array<Person> {
        val realm = Realm.getDefaultInstance()
        val query = realm.where(Person::class.java)
        if (json.has("firstName")) {
            query.contains("firstName", json.getString("firstName"))
        }
        if (json.has("lastName")) {
            query.contains("lastName", json.getString("lastName"))
        }
        if (json.has("age") && json.getInt("age") != -1) {
            query.equalTo("age", json.getInt("age"))
        }
        if (json.has("country")) {
            query.contains("country", json.getString("country"))
        }
        return query.findAll().toTypedArray()
    }

    private fun save(json: JSONObject) {
        val realm = Realm.getDefaultInstance()
        realm.executeTransaction {
            val person = it.createObject(Person::class.java)
            person.firstName = json.getString("firstName")
            person.lastName = json.getString("lastName")
            person.age = json.getInt("age")
            person.country = json.getString("country")
        }
    }
}
