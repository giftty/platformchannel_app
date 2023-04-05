package com.example.platformchannel_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import android.os.Handler
import android.os.Looper
import dreacotdeliverylibagent.Agent
import dreacotdeliverylibagent.Dreacotdeliverylibagent

import kotlin.random.Random



class MainActivity: FlutterActivity() {

    private val CHANNEL = "androidtest2/firstpot"
    private val eventChannel = "androidtest2/firstpot/events"
    var agent: Agent? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                val dir = filesDir.absolutePath
                agent = Dreacotdeliverylibagent.newDreacotDeliveryAgent(dir)
                if(call.method=="connect"){
                    //connect()
                 // result.success("connected")
                }

                if(call.method=="login"){

                  //  agent = TgtSingleton.instance!!.agent;
                    var valuee = login(call.argument<String>("email")!!,call.argument<String>("password")!!)
                    result.success(valuee)
//                    result.success("this result is from the platform backend your email =${call.argument<String>("email")} " +
//                            "password=${call.argument<String>("password")}")
                }
            }
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setStreamHandler(
            CounterHandler
        )
    }

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
