package com.example.channeltest

import dreacotdeliverylibagent.Dreacotdeliverylibagent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import android.os.Handler
import android.os.Looper
import dreacotdeliverylibagent.Agent


import kotlin.random.Random

class MainActivity: FlutterActivity() {
    //method channel name
    private val CHANNEL = "androidtest2/firstpot"

    //event channel name
    private val eventChannel = "androidtest2/firstpot/events"
    var agent: Agent? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                val dir = filesDir.absolutePath
                agent  = Dreacotdeliverylibagent.newDreacotDeliveryAgent(dir)

                if(call.method=="connect"){
                    //connect()
                    // result.success("connected")
                }
                 // test for method call name and run a code. This code listens for a login call method
                 //from flutter and run the login code and return a value .
                if(call.method=="login"){

                    var valuee = login(call.argument<String>("email")!!,call.argument<String>("password")!!)
                    result.success(valuee)
//
                }
            }
        // this is the event broacaster that flutter pages can listen to and recieve data
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setStreamHandler(
            CounterHandler
        )
    }

    //this is a test method that sends int of length 6 to flutter page thats listening every 1 secs
    object CounterHandler : EventChannel.StreamHandler {
        // Handle event in main thread.
        private var handler = Handler(Looper.getMainLooper())

        // Declare our eventSink later it will be initialized
        private var eventSink: EventChannel.EventSink? = null


        override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
            eventSink = sink
            var count: String =" "
            var count2:Int=0
            // every 5 second send the time
            val r: Runnable = object : Runnable {
                override fun run() {
                    val randomValues = List(6) { Random.nextInt(9) }
                    val sb = StringBuilder()
                    randomValues.forEach { sb.append(it)}
                    count= sb.toString()
                    handler.post {
                        count
                        // this is where the event data is being sent.
                        eventSink?.success(listOf(count,count2))
                    }
                    count2++
                    if(count2>60){
                        handler.removeCallbacks(this)
                        //eventSink=null
                    }
                    handler.postDelayed(this, 1000)
                }
            }

            handler.postDelayed(r, 1000)



        }

        override fun onCancel(p0: Any?) {
            eventSink = null
        }
    }

    private fun connect() {
        //   TgtSingleton.instance!!.connect(this)
        if (agent != null) {
            if (!agent!!.isConnected) {
                try {
                    agent!!.connect("178.79.143.134:6061")
                    // TgtSingleton.connected = true
                    // println("Listening for messages: ")
                    // TgtSingleton.authenticated = true
                    //                            activity.sendBroadcast(new Intent(Constants.CONNECT_STATUS));
                    println("Logged IN Broadcast sent")
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
    }

    private fun login(email:String,password:String): String? {

        return try {
            connect()
            // agent = TgtSingleton.instance!!.agent
            print("[][][][][][][][" + agent!!.isConnected)
            val user = agent!!.login(email, password)
            user.toString()
        } catch (e: Exception) {
            e.printStackTrace()
            println(e.message)
            e.message
            //
        }
    }
}
