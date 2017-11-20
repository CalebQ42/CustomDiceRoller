package com.apps.darkstorm.cdr

import android.os.Bundle
import android.support.design.widget.NavigationView
import android.support.v4.view.GravityCompat
import android.support.v7.app.ActionBarDrawerToggle
import android.support.v7.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.app_bar_main.*

class MainActivity : AppCompatActivity(), NavigationView.OnNavigationItemSelectedListener, FormulaFragment.OnFormulaFragmentInteractionListener {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)
        val toggle = ActionBarDrawerToggle(
                this, drawer_layout, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close)
        drawer_layout.addDrawerListener(toggle)
        toggle.syncState()
        nav_view.setNavigationItemSelectedListener(this)
    }

    override fun onBackPressed() {
        if (drawer_layout.isDrawerOpen(GravityCompat.START)) {
            drawer_layout.closeDrawer(GravityCompat.START)
        } else {
            super.onBackPressed()
        }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
//        return when (item.itemId) {
//            R.id.action_settings -> true
//            else -> super.onOptionsItemSelected(item)
//        }
        return super.onOptionsItemSelected(item)
    }

    override fun onNavigationItemSelected(item: MenuItem): Boolean {
        val cur = fragmentManager.findFragmentById(R.id.content_main)
        when (item.itemId) {
            R.id.formula ->{
                if(cur is FormulaFragment)
                    fragmentManager.beginTransaction().replace(R.id.content_main,FormulaFragment.newInstance())
                        .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).commit()
                else
                    fragmentManager.beginTransaction().replace(R.id.content_main,FormulaFragment.newInstance())
                        .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).addToBackStack("formula").commit()
            }
        }
        drawer_layout.closeDrawer(GravityCompat.START)
        return true
    }
}
