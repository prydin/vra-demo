/*
 * Copyright (c) 2020 VMware, Inc
 *
 *  SPDX-License-Identifier: MIT
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package com.vmware.vra.jenkinsplugin.pipeline;

import com.vmware.vra.jenkinsplugin.testutils.FileUtils;
import hudson.EnvVars;
import hudson.slaves.EnvironmentVariablesNodeProperty;
import org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition;
import org.jenkinsci.plugins.workflow.job.WorkflowJob;
import org.jenkinsci.plugins.workflow.job.WorkflowRun;
import org.junit.Test;
import org.jvnet.hudson.test.recipes.WithTimeout;

/// Split into part 1 and 2 to facilitate parallel testing
public class E2EPipelinePart1Test extends E2ETestBase {
  @WithTimeout(600)
  @Test
  public void testDeploymentNoGlobalSettings() {
    final String url = System.getenv("VRA_URL");
    if (url == null) {
      System.err.println("VRA_URL not set. Skipping test");
      return;
    }
    final String token = System.getenv("VRA_TOKEN");
    rr.then(
        r -> {
          final EnvironmentVariablesNodeProperty prop = new EnvironmentVariablesNodeProperty();
          final EnvVars envVars = prop.getEnvVars();
          envVars.put("vraURL", System.getenv("VRA_URL"));
          envVars.put("token", System.getenv("VRA_TOKEN"));
          r.jenkins.getGlobalNodeProperties().add(prop);

          final String pipeline =
              FileUtils.loadResource(
                  "/com/vmware/vra/jenkinsplugin/pipelines/DeployFromCatalogNoGlobalSettings.groovy");
          final WorkflowJob job = r.jenkins.createProject(WorkflowJob.class, "project");
          job.setDefinition(new CpsFlowDefinition(pipeline, true));
          final WorkflowRun b = rr.j.buildAndAssertSuccess(job);
          r.assertLogContains("All deployments finished!", b);
        });
  }

  @WithTimeout(600)
  @Test
  public void testDeployFromCatalogPipeline() {
    testPipeline("/com/vmware/vra/jenkinsplugin/pipelines/DeployFromCatalog.groovy");
  }
}
