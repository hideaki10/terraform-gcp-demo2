package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/shell"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestMicroservicesModule(t *testing.T) {
	expectedName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))

	opts := &terraform.Options{
		TerraformDir: "../microservices/examples",

		Vars: map[string]interface{}{
			"cluster_tfstate_bucket": "tf-state-20210812-test-1",
			"cluster_tfstate_prefix": "terraform/k8s-cluster/terraform_state",
			"service_name":           expectedName,
		},
	}

	defer terraform.Destroy(t, opts)
	_ = terraform.InitAndPlan(t, opts)
	_ = terraform.Apply(t, opts)

	cmd := shell.Command{
		Command: "gcloud",
		Args:    []string{"container", "clusters", "get-credentials", "primary", "--region", "asia-northeast1", "--project", "test-gke-cluster-02-dev"},
	}

	shell.RunCommand(t, cmd)
	kopts := k8s.NewKubectlOptions("", "", expectedName+"-dev")
	str, err := k8s.RunKubectlAndGetOutputE(t, kopts, "run", "--generator", "run-pod/v1", "--serviceaccount", "pod-default", "--image", "google/cloud-sdk:alpine",
		"--rm", "-i", "gcloud-test", "--", "/bin/ash", "-c", "gcloud auth list")

	if err != nil {
		t.Errorf("kubectl run failed: %v", err)
	}
	if !strings.Contains(str, fmt.Sprintf("pod-default@%s.iam.gserviceaccount.com", expectedName+"-dev")) {
		t.Errorf("Unexpected kubectl output: \n%s", str)
	}
}
