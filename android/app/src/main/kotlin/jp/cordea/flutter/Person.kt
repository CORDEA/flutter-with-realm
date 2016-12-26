package jp.cordea.flutter

import io.realm.RealmObject
import org.json.JSONObject

/**
 * Created by Yoshihiro Tanaka on 2016/12/22.
 */
open class Person : RealmObject() {

    open var firstName: String? = null

    open var lastName: String? = null

    open var age: Int = 0

    open var country: String? = null

    fun toJsonObject(): JSONObject {
        val person = JSONObject()
        person.put("firstName", firstName)
        person.put("lastName", lastName)
        person.put("age", age)
        person.put("country", country)
        return person
    }
}