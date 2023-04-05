package com.example.platformchannel_app

import android.app.Activity
import dreacotdeliverylibagent.Agent

class TgtSingleton private constructor() {
    var agent: Agent? = null
    fun connect(activity: Activity?) {
        agent = instance!!.agent
        object : Thread() {
            override fun run() {
                if (agent != null) {
                    if (!agent!!.isConnected) {
                        try {
                            agent!!.connect("178.79.143.134:6061")
                            connected = true
                            println("Listening for messages: ")
                            authenticated = true
                            //                            activity.sendBroadcast(new Intent(Constants.CONNECT_STATUS));
                            println("Logged IN Broadcast sent")
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                }
            }
        }.start()
    }

    companion object {
        var connected = false
        var authenticated = false
        private var tgtSingleton: TgtSingleton? = null
        val instance: TgtSingleton?
            get() {
                if (tgtSingleton == null) {
                    synchronized(TgtSingleton::class.java) {
                        if (tgtSingleton == null) {
                            tgtSingleton =
                                TgtSingleton()
                        }
                    }
                }
                return tgtSingleton
            }
    }

    init {
        if (tgtSingleton != null) {
            throw RuntimeException("Use getInstance() method to get the single instance of this class.")
        }
    }
}