package com.cyanogenmod.RacerParts;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.io.IOException;
import java.util.StringTokenizer;

public class RacerPartsStartup extends BroadcastReceiver
{
    private boolean hasdata = false;
    private int xoffset, yoffset, xscale, yscale, xymix, yxmix;

    private void loadCalData() {
        try {
            FileInputStream fis = new FileInputStream("/data/system/pointercal");
            BufferedReader buf = new BufferedReader(new InputStreamReader(fis));
	    String readString = new String();
	    if ((readString = buf.readLine()) != null) {
                // Split string and parse values
                StringTokenizer st = new StringTokenizer(readString, " ");
	        xscale = Integer.parseInt(st.nextToken());
	        if(!st.hasMoreTokens()) return;
	        xymix = Integer.parseInt(st.nextToken());
	        if(!st.hasMoreTokens()) return;
	        xoffset = Integer.parseInt(st.nextToken());
	        if(!st.hasMoreTokens()) return;
	        yxmix = Integer.parseInt(st.nextToken());
	        if(!st.hasMoreTokens()) return;
	        yscale = Integer.parseInt(st.nextToken());
	        if(!st.hasMoreTokens()) return;
	        yoffset = Integer.parseInt(st.nextToken());
	        if(!st.hasMoreTokens()) return;
	        int temp = Integer.parseInt(st.nextToken().trim());
                hasdata = true;
            }
            fis.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void writeValue(String parameter, int value) {
        try {
            FileOutputStream fos = new FileOutputStream(new File(parameter));
            fos.write(String.valueOf(value).getBytes());
            fos.flush();
            fos.getFD().sync();
            fos.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onReceive(final Context context, final Intent bootintent) {
        // Touchscreen calibration
        loadCalData();
        if(hasdata) {
            writeValue("/sys/module/msm_ts/parameters/tscal_xoffset",xoffset);
            writeValue("/sys/module/msm_ts/parameters/tscal_yoffset",yoffset);
            writeValue("/sys/module/msm_ts/parameters/tscal_xscale",xscale);
            writeValue("/sys/module/msm_ts/parameters/tscal_yscale",yscale);
            writeValue("/sys/module/msm_ts/parameters/tscal_yscale",xymix);
            writeValue("/sys/module/msm_ts/parameters/tscal_yscale",yxmix);
        }
        // Gesture emulation
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(context);
        writeValue("/sys/module/msm_ts/parameters/tscal_gesture_pressure", Integer.parseInt(prefs.getString("gesture_pressure", "1375")));
        writeValue("/sys/module/msm_ts/parameters/tscal_gesture_blindspot", Integer.parseInt(prefs.getString("gesture_blindspot", "30")));
        // USB charging
        if(prefs.getBoolean("usb_charging", true))
            writeValue("/sys/module/msm_battery/parameters/usb_chg_enable", 1);
        else
            writeValue("/sys/module/msm_battery/parameters/usb_chg_enable", 0);
    }
}
