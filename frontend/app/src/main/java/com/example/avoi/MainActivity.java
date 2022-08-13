package com.example.avoi;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity implements View.OnClickListener{

    Button mButton;
    boolean mWhether=false; //버튼 켜져있나 꺼져있나 여부
    String [] permission_list={
        Manifest.permission.CAMERA,
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        checkPermission();

        mButton=(Button) findViewById(R.id.OnOffbtn);
        mButton.setOnClickListener(this);
    }

    //권한 체크 method
    public void checkPermission(){
        //안드로이드 버전이 6.0 미만이면 method 종료
        if(Build.VERSION.SDK_INT<Build.VERSION_CODES.M) {
            return;
        }
        for(String permissson:permission_list){
            int chk=checkCallingOrSelfPermission(permissson);
            if(chk== PackageManager.PERMISSION_DENIED){ //권한 허용여부 확인하는 창 띄우기
                requestPermissions(permission_list,0);
            }
        }
    }

    //권한 허가가 안되있으면 앱 종료
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if(requestCode==0){
            for(int i=0; i<grantResults.length; i++){
                if(grantResults[i]==PackageManager.PERMISSION_DENIED){//권한을 하나라도 허용하지 않는다면 앱 종료
                    Toast.makeText(getApplicationContext(),"앱권한을 허용해야 합니다",Toast.LENGTH_LONG).show();
                    finish();
                }
            }
        }
    }

    //OnOff 버튼 클릭시 서비스 실행/종료
    @Override
    public void onClick(View view) {
        if(mWhether){
            //service 실행
        }
        else{
            //service 종료
        }
    }
}